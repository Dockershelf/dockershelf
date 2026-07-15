# -*- coding: utf-8 -*-
#
# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2023, Dockershelf Developers.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

import fnmatch
import gzip
import os
import re
from contextlib import closing
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from packaging.version import Version

from .logger import logger

debian_release_url_holder = "http://deb.debian.org/debian/dists/{0}/Release"
debian_suites = ["oldstable", "stable", "testing", "unstable"]

node_suites = ["18", "20", "22", "24", "26"]

# https://apt.dockershelf.com/dockershelf
python_suites = ["3.10", "3.11", "3.12", "3.13", "3.14"]

dockershelf_apt_url = "https://apt.dockershelf.com/dockershelf"
dockershelf_apt_packages_url = dockershelf_apt_url + "/dists/{suite}/main/binary-amd64/Packages.gz"
dockershelf_apt_suites = ("trixie", "unstable")
go_suites = ["1.22", "1.23", "1.24", "1.25", "1.26"]


def u(u_string):
    if isinstance(u_string, str):
        return u_string
    return u_string.decode("utf-8")


def s(s_string):
    if isinstance(s_string, bytes):
        return s_string
    return s_string.encode("utf-8")


def find_dirs(path=None, pattern="*"):
    assert isinstance(path, str)
    assert isinstance(pattern, str)

    dirlist = []
    for directory, subdirs, _ in os.walk(os.path.normpath(path)):
        for subdir in fnmatch.filter(subdirs, pattern):
            if os.path.isdir(os.path.join(directory, subdir)):
                dirlist.append(os.path.join(directory, subdir))
    return dirlist


def is_string_an_int(s):
    try:
        int(s)
        return True
    except ValueError:
        return False


def is_string_a_float(s):
    try:
        float(s)
        return True
    except ValueError:
        return False


def is_string_a_string(s):
    return not (is_string_a_float(s) or is_string_an_int(s))


def get_debian_versions():
    logger.info("Getting Debian versions")
    debian_versions = []

    for debian_suite in debian_suites:
        debian_release_url = debian_release_url_holder.format(debian_suite)

        r = Request(debian_release_url)
        r.add_header("Range", "bytes={0}-{1}".format(0, 256))

        with closing(urlopen(r)) as d:
            debian_release_content = d.read()

        debian_versions.append((u(re.findall("Codename: (.*)", u(debian_release_content))[0]), u(debian_suite)))

    return debian_versions


def get_node_versions():
    logger.info("Getting Node versions")
    node_versions = [u(v) for v in node_suites]
    return sorted(set(node_versions), key=lambda x: Version(x))


def get_python_versions():
    logger.info("Getting Python versions")
    python_versions = [u(v) for v in python_suites]
    return sorted(python_versions, key=lambda x: Version(x))


def _fetch_apt_packages(suite, timeout=60):
    request = Request(
        dockershelf_apt_packages_url.format(suite=suite),
        headers={"User-Agent": "dockershelf-discover/1.0"},
    )
    with closing(urlopen(request, timeout=timeout)) as response:
        return response.read()


def get_go_versions():
    logger.info("Getting Go versions")

    go_versions_index = {}
    package_pattern = re.compile(r"^Package: golang-(\d+\.\d+)-go$", re.MULTILINE)
    version_pattern = re.compile(r"^Version: (\d+\.\d+\.\d+)", re.MULTILINE)

    for suite in dockershelf_apt_suites:
        try:
            packages = gzip.decompress(_fetch_apt_packages(suite)).decode("utf-8", errors="replace")
        except (HTTPError, URLError):
            continue

        # Split into stanzas and extract Package + Version for golang-X.Y-go.
        for stanza in packages.strip().split("\n\n"):
            pkg_match = package_pattern.search(stanza)
            if not pkg_match:
                continue
            minor = pkg_match.group(1)
            if minor not in go_suites:
                continue
            ver_match = version_pattern.search(stanza)
            if not ver_match:
                continue
            upstream = ver_match.group(1)
            try:
                parsedv = Version(upstream)
            except Exception:
                continue
            if minor not in go_versions_index:
                go_versions_index[minor] = Version("0.0")
            if parsedv > go_versions_index[minor]:
                go_versions_index[minor] = parsedv

    go_versions = [f"{v.major}.{v.minor}.{v.micro}" for v in go_versions_index.values()]
    return sorted(set(go_versions), key=lambda x: Version(x))
