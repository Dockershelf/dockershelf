#!/usr/bin/env python3
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-2017, Dockershelf Developers.
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
import sys
import fnmatch

try:
    from HTMLParser import HTMLParser
except ImportError:
    from html.parser import HTMLParser

if not sys.version_info < (3,):
    unicode = str
    basestring = str


def find_dirs(path=None, pattern='*'):
    assert isinstance(path, basestring)
    assert isinstance(pattern, basestring)

    dirlist = []
    for directory, subdirs, files in os.walk(os.path.normpath(path)):
        for subdir in fnmatch.filter(subdirs, pattern):
            if os.path.isdir(os.path.join(directory, subdir)):
                dirlist.append(os.path.join(directory, subdir))
    return dirlist


class MongoVersionParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        if attrs:
            dlstr = attrs[0][1]
            # dlstr = dlstr.replace('http://downloads.mongodb.org/src/mongodb-src-v', '')
            # dlstr = dlstr.replace('http://downloads.mongodb.org/src/mongodb-src-r', '')
            # dlstr = dlstr.replace('http://downloads.mongodb.org/src/mongodb-src-', '')
            # dlstr = dlstr.replace('.tar.gz.sig', '')
            # dlstr = dlstr.replace('.tar.gz.md5', '')
            # dlstr = dlstr.replace('.tar.gz.sha1', '')
            # dlstr = dlstr.replace('.tar.gz.sha256', '')
            # dlstr = dlstr.replace('.tar.gz', '')
            # dlstr = dlstr.replace('.tgz.sig', '')
            # dlstr = dlstr.replace('.tgz.md5', '')
            # dlstr = dlstr.replace('.tgz.sha1', '')
            # dlstr = dlstr.replace('.tgz.sha256', '')
            # dlstr = dlstr.replace('.tgz', '')
            # dlstr = dlstr.replace('.zip.sig', '')
            # dlstr = dlstr.replace('.zip.md5', '')
            # dlstr = dlstr.replace('.zip.sha1', '')
            # dlstr = dlstr.replace('.zip.sha256', '')
            # dlstr = dlstr.replace('.zip', '')
            # dlstr = dlstr.replace('-cut', '')
            # dlstr = dlstr.replace('-latest', '')
            # dlstr = dlstr.replace('latest', '')
            # dlstr = re.sub('-rc.*', '', dlstr)
            # dlstr = re.sub('_rc.*', '', dlstr)
            dlstr = dlstr.replace('..', '')
            dlstr = dlstr.replace('development', '')
            dlstr = dlstr.replace('testing', '')
            self.dlstr = dlstr
