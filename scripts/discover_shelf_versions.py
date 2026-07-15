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

DOCKERSHELF_APT_URL = "https://apt.dockershelf.com/dockershelf"
DOCKERSHELF_APT_PACKAGES_URL = DOCKERSHELF_APT_URL + "/dists/{suite}/main/binary-amd64/Packages.gz"
DOCKERSHELF_APT_SUITES = ("trixie", "unstable")
MIN_NODE_MAJOR = 16
MIN_PYTHON_MINOR = Version("3.10")


def _fetch(url, timeout=60):
    request = Request(url, headers={"User-Agent": "dockershelf-discover/1.0"})
    with closing(urlopen(request, timeout=timeout)) as response:
        return response.read()


def _head_ok(url, timeout=20):
    request = Request(url, method="HEAD", headers={"User-Agent": "dockershelf-discover/1.0"})
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
    raise ValueError("Could not find {0} in utils.py".format(name))


def load_utils_lists(utils_path):
    with open(utils_path, "r") as handle:
        source = handle.read()
    return {
        "python_suites": _read_list_assign(source, "python_suites"),
        "node_suites": _read_list_assign(source, "node_suites"),
        "go_suites": _read_list_assign(source, "go_suites"),
    }


def discover_dockershelf_python_minors():
    """Discover Python minor versions available as versioned packages
    (``python3.X``) in the Dockershelf APT repository.

    Scans the ``Packages.gz`` index of each configured suite and extracts
    ``python3.X`` package names. Only versions ``>= MIN_PYTHON_MINOR`` are
    returned.
    """
    available = set()
    pattern = re.compile(r"^Package: (python3\.\d+)$", re.MULTILINE)
    for suite in DOCKERSHELF_APT_SUITES:
        try:
            packages = gzip.decompress(_fetch(DOCKERSHELF_APT_PACKAGES_URL.format(suite=suite)))
        except (HTTPError, URLError):
            continue
        for package in pattern.findall(packages.decode("utf-8", errors="replace")):
            available.add(package.replace("python", ""))
    return sorted(
        [v for v in available if Version(v) >= MIN_PYTHON_MINOR],
        key=lambda value: Version(value),
    )


def discover_python_versions(repo_root):
    available = discover_dockershelf_python_minors()
    return available, []


def discover_node_majors():
    """Discover Node major versions available as versioned packages
    (``nodejs-XX``) in the Dockershelf APT repository.

    Scans the ``Packages.gz`` index of each configured suite and extracts
    ``nodejs-XX`` package names. Only even majors ``>= MIN_NODE_MAJOR`` are
    returned, matching Dockershelf's LTS-eligible policy.
    """
    pattern = re.compile(r"^Package: nodejs-(\d+)$", re.MULTILINE)
    available_majors = set()
    for suite in DOCKERSHELF_APT_SUITES:
        try:
            packages = gzip.decompress(_fetch(DOCKERSHELF_APT_PACKAGES_URL.format(suite=suite)))
        except (HTTPError, URLError):
            continue
        for major in pattern.findall(packages.decode("utf-8", errors="replace")):
            if int(major) < MIN_NODE_MAJOR:
                continue
            if int(major) % 2 != 0:
                continue
            available_majors.add(major)

    return sorted(available_majors, key=lambda value: int(value))


def discover_go_minors():
    """Discover Go minor versions available as versioned packages
    (``golang-X.Y-go``) in the Dockershelf APT repository.

    Scans the ``Packages.gz`` index of each configured suite and extracts
    ``golang-X.Y-go`` package names.
    """
    pattern = re.compile(r"^Package: golang-(\d+\.\d+)-go$", re.MULTILINE)
    available = set()
    for suite in DOCKERSHELF_APT_SUITES:
        try:
            packages = gzip.decompress(_fetch(DOCKERSHELF_APT_PACKAGES_URL.format(suite=suite)))
        except (HTTPError, URLError):
            continue
        for minor in pattern.findall(packages.decode("utf-8", errors="replace")):
            available.add(minor)
    return sorted(available, key=lambda value: Version(value))


def recommend_list(current, upstream_available, cap):
    current = [str(v) for v in current]
    upstream_sorted = sorted(
        [str(v) for v in upstream_available],
        key=lambda value: Version(value) if "." in value else int(value),
    )
    recommended = upstream_sorted[-cap:]
    add = [v for v in recommended if v not in current]
    remove = [v for v in current if v not in recommended]
    return {
        "current": current,
        "upstream_available": upstream_sorted,
        "recommended": recommended,
        "add": add,
        "remove": remove,
        "changed": add != [] or remove != [],
        "cap": cap,
    }


def shelf_report(name, current, upstream_available, cap, extra=None):
    report = recommend_list(current, upstream_available, cap)
    report["shelf"] = name
    if extra:
        report.update(extra)
    return report


def discover_all(repo_root):
    lists = load_utils_lists(os.path.join(repo_root, "scripts", "utils.py"))
    python_upstream, python_unbuildable = discover_python_versions(repo_root)
    return {
        "python": shelf_report(
            "python",
            lists["python_suites"],
            python_upstream,
            len(lists["python_suites"]),
            {"needs_build_script": python_unbuildable},
        ),
        "node": shelf_report(
            "node",
            lists["node_suites"],
            discover_node_majors(),
            len(lists["node_suites"]),
        ),
        "go": shelf_report(
            "go",
            lists["go_suites"],
            discover_go_minors(),
            len(lists["go_suites"]),
        ),
    }


def _format_list(values):
    return ", ".join(["'{0}'".format(value) for value in values])


def apply_utils_lists(utils_path, reports):
    with open(utils_path, "r") as handle:
        content = handle.read()

    replacements = {
        "python_suites": reports["python"]["recommended"],
        "node_suites": reports["node"]["recommended"],
        "go_suites": reports["go"]["recommended"],
    }
    for name, values in replacements.items():
        pattern = r"^({0} = \[)(.*?)(\])".format(name)
        replacement = r"\1{0}\3".format(_format_list(values))
        content, count = re.subn(pattern, replacement, content, count=1, flags=re.MULTILINE | re.DOTALL)
        if count != 1:
            raise ValueError("Failed to update {0} in utils.py".format(name))

    with open(utils_path, "w") as handle:
        handle.write(content)


def main(argv=None):
    parser = argparse.ArgumentParser(description="Discover Dockershelf shelf version updates")
    parser.add_argument(
        "--repo-root",
        default=os.path.dirname(os.path.dirname(os.path.realpath(__file__))),
    )
    parser.add_argument("--json", action="store_true", help="Print JSON report")
    parser.add_argument("--apply", action="store_true", help="Write recommended lists to scripts/utils.py")
    args = parser.parse_args(argv)

    reports = discover_all(args.repo_root)
    any_changed = any(report["changed"] for report in reports.values())

    if args.json:
        print(json.dumps(reports, indent=2, sort_keys=True))
    else:
        for name in ("python", "node", "go"):
            report = reports[name]
            print("[{0}] cap={1}".format(name, report["cap"]))
            print("  current:     {0}".format(", ".join(report["current"]) or "(empty)"))
            print("  recommended: {0}".format(", ".join(report["recommended"]) or "(empty)"))
            if report["add"]:
                print("  add:         {0}".format(", ".join(report["add"])))
            if report["remove"]:
                print("  remove:      {0}".format(", ".join(report["remove"])))
            if not report["changed"]:
                print("  status:      up to date")
            if name == "python" and report.get("needs_build_script"):
                print(
                    "  note:        will extend build-image.sh for: {0}".format(", ".join(report["needs_build_script"]))
                )

    if args.apply:
        if not any_changed:
            print("No shelf list changes to apply.", file=sys.stderr)
            return 0
        apply_utils_lists(os.path.join(args.repo_root, "scripts", "utils.py"), reports)
        print("Applied recommended lists to scripts/utils.py", file=sys.stderr)

    return 0


if __name__ == "__main__":
    sys.exit(main())
