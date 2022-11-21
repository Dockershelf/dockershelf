# -*- coding: utf-8 -*-
#
# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2022, Dockershelf Developers.

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

import os
import re
import fnmatch
from contextlib import closing

from urllib.request import urlopen, Request

from packaging.version import Version

from .logger import logger


debian_release_url_holder = 'http://deb.debian.org/debian/dists/{0}/Release'
debian_suites = ['oldstable', 'stable', 'testing', 'unstable']

node_versions_list_file = ('https://raw.githubusercontent.com/nodesource/'
                           'distributions/master/deb/src/build.sh')
node_version_lower_limit = 12
node_version_upper_limit = 18
node_versions_disabled = ['13', '15', '17']

python_suites = [
    '2.7',
    '3.5',
    '3.7',
    '3.9',
    '3.10',
    '3.11',
]


def u(u_string):
    if isinstance(u_string, str):
        return u_string
    return u_string.decode('utf-8')


def s(s_string):
    if isinstance(s_string, bytes):
        return s_string
    return s_string.encode('utf-8')


def find_dirs(path=None, pattern='*'):
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
    logger.info('Getting Debian versions')
    debian_versions = []

    for debian_suite in debian_suites:
        debian_release_url = debian_release_url_holder.format(debian_suite)

        r = Request(debian_release_url)
        r.add_header('Range', 'bytes={0}-{1}'.format(0, 256))

        with closing(urlopen(r)) as d:
            debian_release_content = d.read()

        debian_versions.append(
            (u(re.findall('Codename: (.*)', u(debian_release_content))[0]),
             u(debian_suite)))

    return debian_versions


def get_node_versions():
    logger.info('Getting Node versions')

    with closing(urlopen(node_versions_list_file)) as n:
        node_versions_list_content = n.read()

    node_versions = re.findall(r'node_(\d*)\.x:_\d*\.x:nodejs:Node\.js \d*\.x',
                               u(node_versions_list_content))
    node_versions = [u(v) for v in node_versions
                     if (float(v) >= node_version_lower_limit and
                         float(v) <= node_version_upper_limit)]
    node_versions = list(set(node_versions) - set(node_versions_disabled))
    return sorted(set(node_versions), key=lambda x: Version(x))


def get_python_versions():
    logger.info('Getting Python versions')
    python_versions = [u(v) for v in python_suites]
    return sorted(python_versions, key=lambda x: Version(x))
