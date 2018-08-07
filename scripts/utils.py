#!/usr/bin/env python3
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-2018, Dockershelf Developers.
#
#   Please refer to AUTHORS.md for a complete list of Copyright holders.
#
#   Dockershelf is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Dockershelf is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see http://www.gnu.org/licenses.

import os
import re
import sys
import fnmatch
from contextlib import closing

try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

if not sys.version_info < (3,):
    unicode = str
    basestring = str


def u(u_string):
    if isinstance(u_string, unicode):
        return u_string
    return u_string.decode('utf-8')


def find_dirs(path=None, pattern='*'):
    assert isinstance(path, basestring)
    assert isinstance(pattern, basestring)

    dirlist = []
    for directory, subdirs, files in os.walk(os.path.normpath(path)):
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
    debian_release_url_holder = ('https://deb.debian.org/debian/dists/{0}/'
                                 'Release')
    debian_suites = ['oldoldstable', 'oldstable', 'stable', 'testing',
                     'unstable']
    debian_versions = []

    for debian_suite in debian_suites:
        debian_release_url = debian_release_url_holder.format(debian_suite)

        r = Request(debian_release_url)
        r.add_header('Range', 'bytes={0}-{1}'.format(0, 256))

        with closing(urlopen(r)) as d:
            debian_release_content = d.read()

        debian_versions.append(
            (re.findall('Codename: (.*)', u(debian_release_content))[0],
             debian_suite))

    return debian_versions
