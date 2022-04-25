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
import sys
import fnmatch
from contextlib import closing

from urllib.request import urlopen, Request

import lxml.html
from packaging.version import Version

from .logger import logger


debian_release_url_holder = 'http://deb.debian.org/debian/dists/{0}/Release'
debian_suites = ['oldstable', 'stable', 'testing', 'unstable']

mongo_debian_releases_url = \
    'http://repo.mongodb.org/apt/debian/dists/index.html'
mongo_rel_url_holder = \
    'http://repo.mongodb.org/apt/debian/dists/{0}/mongodb-org/index.html'
mongo_version_lower_limit = 4.2
mongo_version_upper_limit = 5.0

node_versions_list_file = \
    'https://raw.githubusercontent.com/nodesource/distributions/master/deb/src/build.sh'
node_version_lower_limit = 10
node_version_upper_limit = 17
node_versions_disabled = ['11', '13']

odoo_versions_list_file = 'http://nightly.odoo.com/index.html'
odoo_version_lower_limit = 11.0
odoo_version_upper_limit = 15.0

postgres_release_url = 'http://apt.postgresql.org/pub/repos/apt/dists/sid-pgdg/Release'
postgres_version_lower_limit = 9.6
postgres_version_upper_limit = 14

php_versions_src_origin = {
    '7.0': 'stretch',
    '7.3': 'buster',
    '7.4': 'bullseye',
    '8.1': 'sid',
}

python_versions_src_origin = {
    '2.7': 'sid',
    '3.5': 'sid',
    '3.6': 'sid',
    '3.7': 'sid',
    '3.9': 'sid',
    '3.10': 'sid',
    '3.11': 'sid',
}

ruby_versions_src_origin = {
    '2.3': 'stretch',
    '2.5': 'buster',
    '2.7': 'sid',
    '3.0': 'sid',
}


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


def get_mongo_versions_src_origin(debian_versions):
    logger.info('Getting Mongo versions')

    mongo_debian_releases_html = lxml.html.parse(
        mongo_debian_releases_url).getroot()
    mongo_debian_releases = mongo_debian_releases_html.cssselect('a')
    mongo_debian_releases = [e.get('href') for e in mongo_debian_releases]
    mongo_debian_releases = [e for e in mongo_debian_releases if e != '..']
    debian_codenames = list(map(lambda x: x[0], debian_versions))
    mongo_debian_releases = list(filter(lambda x: x in debian_codenames,
                                        mongo_debian_releases))
    mongo_debian_releases = sorted(mongo_debian_releases, reverse=True,
                                   key=lambda x: debian_codenames.index(x))

    mongo_versions = []
    for debian_version in mongo_debian_releases:
        mongo_rel_url = mongo_rel_url_holder.format(debian_version)
        mongo_rel_html = lxml.html.parse(mongo_rel_url).getroot()
        mongo_rel = mongo_rel_html.cssselect('a')
        mongo_rel = [e.get('href') for e in mongo_rel]
        mongo_rel = [e for e in mongo_rel if e != '..']
        mongo_rel = list(filter(lambda x: not is_string_a_string(x),
                                mongo_rel))
        mongo_rel = [{e: debian_version} for e in mongo_rel
                     if not any(e in v for v in mongo_versions)]
        mongo_versions.extend(mongo_rel)

    return dict((key, d[key]) for d in mongo_versions for key in d)


def get_mongo_versions(mongo_versions_src_origin):
    mongo_versions = mongo_versions_src_origin.keys()
    mongo_versions = filter(lambda x: int(x[-1]) % 2 == 0, mongo_versions)
    mongo_versions = [u(v) for v in mongo_versions
                      if (float(v) >= mongo_version_lower_limit and
                          float(v) <= mongo_version_upper_limit)]
    return sorted(set(mongo_versions), key=lambda x: Version(x))


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


def get_odoo_versions():
    logger.info('Getting Odoo versions')

    odoo_ver_html = lxml.html.parse(odoo_versions_list_file).getroot()
    odoo_versions = odoo_ver_html.cssselect('a.label')
    odoo_versions = [e.text_content() for e in odoo_versions]
    odoo_versions = list(filter(lambda x: not is_string_a_string(x),
                                odoo_versions))
    odoo_versions = [u(v) for v in odoo_versions
                     if (float(v) >= odoo_version_lower_limit and
                         float(v) <= odoo_version_upper_limit)]
    return sorted(set(odoo_versions), key=lambda x: Version(x))


def get_postgres_versions():
    logger.info('Getting Postgres versions')

    r = Request(postgres_release_url)

    with closing(urlopen(r)) as d:
        postgres_release_content = d.read()

    postgres_versions = re.findall('Components: (.*)',
                                   u(postgres_release_content))[0]
    postgres_versions = list(filter(lambda x: not is_string_a_string(x),
                                    postgres_versions.split()))
    postgres_versions = [u(v) for v in postgres_versions
                         if (float(v) >= postgres_version_lower_limit and
                             float(v) <= postgres_version_upper_limit)]
    return sorted(postgres_versions, key=lambda x: Version(x))


def get_php_versions_src_origin():
    return php_versions_src_origin


def get_php_versions(php_versions_src_origin):
    logger.info('Getting PHP versions')
    php_versions = php_versions_src_origin.keys()
    php_versions = [u(v) for v in php_versions]
    return sorted(php_versions, key=lambda x: Version(x))


def get_python_versions_src_origin():
    return python_versions_src_origin


def get_python_versions(python_versions_src_origin):
    logger.info('Getting Python versions')
    python_versions = python_versions_src_origin.keys()
    python_versions = [u(v) for v in python_versions]
    return sorted(python_versions, key=lambda x: Version(x))


def get_ruby_versions_src_origin():
    return ruby_versions_src_origin


def get_ruby_versions(ruby_versions_src_origin):
    logger.info('Getting Ruby versions')
    ruby_versions = ruby_versions_src_origin.keys()
    ruby_versions = [u(v) for v in ruby_versions]
    return sorted(ruby_versions, key=lambda x: Version(x))
