# -*- coding: utf-8 -*-
#
# Discover upstream Python / Node / Go versions and recommend shelf list updates
# under Dockershelf cap policy (keep N newest buildable versions).

import argparse
import ast
import gzip
import json
import os
import re
import sys
from contextlib import closing
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from packaging.version import Version

from .utils import go_versions_list_file

NODE_INDEX_URL = 'https://nodejs.org/dist/index.json'
NODE_REPO_URL = 'https://deb.nodesource.com/node_{major}.x/dists/nodistro/Release'
DEADSNAKES_PACKAGES_URL = (
    'http://ppa.launchpad.net/deadsnakes/ppa/ubuntu/dists/{suite}/main/binary-amd64/Packages.gz'
)
DEADSNAKES_SUITES = ('jammy', 'noble')
MIN_NODE_MAJOR = 16
MIN_PYTHON_MINOR = Version('3.10')


def _fetch(url, timeout=60):
    request = Request(url, headers={'User-Agent': 'dockershelf-discover/1.0'})
    with closing(urlopen(request, timeout=timeout)) as response:
        return response.read()


def _head_ok(url, timeout=20):
    request = Request(url, method='HEAD', headers={'User-Agent': 'dockershelf-discover/1.0'})
    try:
        with closing(urlopen(request, timeout=timeout)) as response:
            return 200 <= response.status < 400
    except HTTPError as exc:
        return 200 <= exc.code < 400
    except URLError:
        return False


def _read_list_assign(source, name):
    module = ast.parse(source)
    for node in module.body:
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id == name:
                    return ast.literal_eval(node.value)
    raise ValueError('Could not find {0} in utils.py'.format(name))


def load_utils_lists(utils_path):
    with open(utils_path, 'r') as handle:
        source = handle.read()
    return {
        'python_suites': _read_list_assign(source, 'python_suites'),
        'node_suites': _read_list_assign(source, 'node_suites'),
        'go_suites': _read_list_assign(source, 'go_suites'),
    }


def buildable_python_minors(repo_root):
    build_script = os.path.join(repo_root, 'python', 'build-image.sh')
    with open(build_script, 'r') as handle:
        content = handle.read()
    minors = set(re.findall(r'== "(\d+\.\d+)"', content))
    return sorted(minors, key=lambda value: Version(value))


def discover_deadsnakes_python_minors():
    available = set()
    pattern = re.compile(r'^Package: (python3\.\d+)$', re.MULTILINE)
    for suite in DEADSNAKES_SUITES:
        packages = gzip.decompress(_fetch(DEADSNAKES_PACKAGES_URL.format(suite=suite)))
        for package in pattern.findall(packages.decode('utf-8', errors='replace')):
            available.add(package.replace('python', ''))
    return sorted(
        [v for v in available if Version(v) >= MIN_PYTHON_MINOR],
        key=lambda value: Version(value),
    )


def discover_python_versions(repo_root):
    deadsnakes = discover_deadsnakes_python_minors()
    buildable = set(buildable_python_minors(repo_root))
    needs_build_script = sorted(
        [v for v in deadsnakes if v not in buildable],
        key=lambda value: Version(value),
    )
    return deadsnakes, needs_build_script


def discover_node_majors():
    index = json.loads(_fetch(NODE_INDEX_URL).decode('utf-8'))
    majors = set()
    for entry in index:
        version = entry.get('version', '').lstrip('v')
        try:
            parsed = Version(version)
        except Exception:
            continue
        if parsed.major < MIN_NODE_MAJOR:
            continue
        if parsed.major % 2 != 0:
            continue
        majors.add(str(parsed.major))
    available = []
    for major in sorted(majors, key=lambda value: int(value)):
        if _head_ok(NODE_REPO_URL.format(major=major)):
            available.append(major)
    return available


def discover_go_minors():
    content = json.loads(_fetch(go_versions_list_file).decode('utf-8'))
    minors = set()
    for version in content.get('GoVersion', []):
        version = version.removeprefix('go')
        try:
            parsed = Version(version)
        except Exception:
            continue
        minors.add('{0}.{1}'.format(parsed.major, parsed.minor))
    return sorted(minors, key=lambda value: Version(value))


def recommend_list(current, upstream_available, cap):
    current = [str(v) for v in current]
    upstream_sorted = sorted(
        [str(v) for v in upstream_available],
        key=lambda value: Version(value) if '.' in value else int(value),
    )
    recommended = upstream_sorted[-cap:]
    add = [v for v in recommended if v not in current]
    remove = [v for v in current if v not in recommended]
    return {
        'current': current,
        'upstream_available': upstream_sorted,
        'recommended': recommended,
        'add': add,
        'remove': remove,
        'changed': add != [] or remove != [],
        'cap': cap,
    }


def shelf_report(name, current, upstream_available, cap, extra=None):
    report = recommend_list(current, upstream_available, cap)
    report['shelf'] = name
    if extra:
        report.update(extra)
    return report


def discover_all(repo_root):
    lists = load_utils_lists(os.path.join(repo_root, 'scripts', 'utils.py'))
    python_upstream, python_unbuildable = discover_python_versions(repo_root)
    return {
        'python': shelf_report(
            'python',
            lists['python_suites'],
            python_upstream,
            len(lists['python_suites']),
            {'needs_build_script': python_unbuildable},
        ),
        'node': shelf_report(
            'node',
            lists['node_suites'],
            discover_node_majors(),
            len(lists['node_suites']),
        ),
        'go': shelf_report(
            'go',
            lists['go_suites'],
            discover_go_minors(),
            len(lists['go_suites']),
        ),
    }


def _format_list(values):
    return ', '.join(["'{0}'".format(value) for value in values])


def apply_utils_lists(utils_path, reports):
    with open(utils_path, 'r') as handle:
        content = handle.read()

    replacements = {
        'python_suites': reports['python']['recommended'],
        'node_suites': reports['node']['recommended'],
        'go_suites': reports['go']['recommended'],
    }
    for name, values in replacements.items():
        pattern = r'^({0} = \[)(.*?)(\])'.format(name)
        replacement = r"\1{0}\3".format(_format_list(values))
        content, count = re.subn(pattern, replacement, content, count=1, flags=re.MULTILINE | re.DOTALL)
        if count != 1:
            raise ValueError('Failed to update {0} in utils.py'.format(name))

    with open(utils_path, 'w') as handle:
        handle.write(content)


def ensure_python_build_support(repo_root, new_minors):
    if not new_minors:
        return False
    build_script = os.path.join(repo_root, 'python', 'build-image.sh')
    with open(build_script, 'r') as handle:
        content = handle.read()
    original = content

    for minor in new_minors:
        if minor in buildable_python_minors(repo_root):
            continue
        jammy_chain = re.search(
            r'(elif \[ "\$\{PYTHON_VER_NUM_MINOR\}" == "3\.11" )(.*?)( \]; then)',
            content,
            re.DOTALL,
        )
        if not jammy_chain:
            raise ValueError('Could not find Python jammy elif chain in build-image.sh')
        inner = jammy_chain.group(2)
        if minor not in inner:
            inner = inner + ' || [ "${{PYTHON_VER_NUM_MINOR}}" == "{0}" ]'.format(minor)
            content = content[:jammy_chain.start(2)] + inner + content[jammy_chain.end(2):]

        ver_chain = re.search(
            r'(if \[ "\$\{PYTHON_VER_NUM\}" == "3\.11" )(.*?)( \]; then)',
            content,
            re.DOTALL,
        )
        if not ver_chain:
            raise ValueError('Could not find Python symlink if chain in build-image.sh')
        inner = ver_chain.group(2)
        if minor not in inner:
            inner = inner + ' || [ "${{PYTHON_VER_NUM}}" == "{0}" ]'.format(minor)
            content = content[:ver_chain.start(2)] + inner + content[ver_chain.end(2):]

    if content != original:
        with open(build_script, 'w') as handle:
            handle.write(content)
        return True
    return False


def main(argv=None):
    parser = argparse.ArgumentParser(description='Discover Dockershelf shelf version updates')
    parser.add_argument(
        '--repo-root',
        default=os.path.dirname(os.path.dirname(os.path.realpath(__file__))),
    )
    parser.add_argument('--json', action='store_true', help='Print JSON report')
    parser.add_argument('--apply', action='store_true', help='Write recommended lists to scripts/utils.py')
    parser.add_argument(
        '--skip-python-build-script',
        action='store_true',
        help='Do not extend python/build-image.sh for newly discovered Python minors',
    )
    args = parser.parse_args(argv)

    reports = discover_all(args.repo_root)
    any_changed = any(report['changed'] for report in reports.values())

    if args.json:
        print(json.dumps(reports, indent=2, sort_keys=True))
    else:
        for name in ('python', 'node', 'go'):
            report = reports[name]
            print('[{0}] cap={1}'.format(name, report['cap']))
            print('  current:     {0}'.format(', '.join(report['current']) or '(empty)'))
            print('  recommended: {0}'.format(', '.join(report['recommended']) or '(empty)'))
            if report['add']:
                print('  add:         {0}'.format(', '.join(report['add'])))
            if report['remove']:
                print('  remove:      {0}'.format(', '.join(report['remove'])))
            if not report['changed']:
                print('  status:      up to date')
            if name == 'python' and report.get('needs_build_script'):
                print('  note:        will extend build-image.sh for: {0}'.format(
                    ', '.join(report['needs_build_script'])))

    if args.apply:
        if not any_changed:
            print('No shelf list changes to apply.', file=sys.stderr)
            return 0
        if not args.skip_python_build_script:
            ensure_python_build_support(args.repo_root, reports['python']['add'])
        apply_utils_lists(os.path.join(args.repo_root, 'scripts', 'utils.py'), reports)
        print('Applied recommended lists to scripts/utils.py', file=sys.stderr)

    return 0


if __name__ == '__main__':
    sys.exit(main())
