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
import re
import sys
import shutil
from contextlib import closing

try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

from utils import find_dirs

if not sys.version_info < (3,):
    unicode = str
    basestring = str


def update_debian(basedir):

    travis_matrixlist = []
    debian_readme_tablelist = []
    debiandir = os.path.join(basedir, 'debian')
    debian_dockerfile_template = os.path.join(debiandir, 'Dockerfile.template')
    debian_readme_template = os.path.join(debiandir, 'README.md.template')
    debian_readme = os.path.join(debiandir, 'README.md')
    debian_suites = ['oldoldstable', 'oldstable', 'stable', 'testing',
                     'unstable']

    debian_release_url_holder = ('https://deb.debian.org/debian/dists/{0}/'
                                 'Release')
    docker_tag_holder = 'dockershelf/debian:{0}'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-debian%2F{0}%2FDockerfile-blue.svg')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/debian/{0}/Dockerfile')
    microbadger_badge_holder = ('https://images.microbadger.com/badges/'
                                'image/dockershelf/debian:{0}.svg')
    microbadger_url_holder = ('https://microbadger.com/images/dockershelf/'
                              'debian:{0}')
    travis_matrixlist_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/debian:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/debian:{1}"')
    debian_readme_tablelist_holder = ('|[`{0}`]({1})'
                                      '|`{2}`'
                                      '|[![]({3})]({4})'
                                      '|[![]({5})]({6})|')

    for deldir in find_dirs(debiandir):
        shutil.rmtree(deldir)

    for debian_suite in debian_suites:
        base_image = 'scratch'
        debian_release_url = debian_release_url_holder.format(debian_suite)

        r = Request(debian_release_url)
        r.add_header('Range', 'bytes={0}-{1}'.format(0, 256))

        with closing(urlopen(r)) as d:
            debian_releases_content = d.read()

        debian_codename = re.findall('Codename: (.*)',
                                     debian_releases_content)[0]
        debian_codename_dir = os.path.join(debiandir, debian_codename)
        debian_dockerfile = os.path.join(debian_codename_dir, 'Dockerfile')
        docker_tag = docker_tag_holder.format(debian_codename)
        docker_url = 'https://hub.docker.com/r/dockershelf/debian'
        dockerfile_badge = dockerfile_badge_holder.format(debian_codename)
        dockerfile_url = dockerfile_url_holder.format(debian_codename)
        microbadger_badge = microbadger_badge_holder.format(debian_codename)
        microbadger_url = microbadger_url_holder.format(debian_codename)

        travis_matrixlist.append(travis_matrixlist_str.format(
            debian_codename, debian_suite))
        debian_readme_tablelist.append(debian_readme_tablelist_holder.format(
            docker_tag, docker_url, debian_codename, dockerfile_badge,
            dockerfile_url, microbadger_badge, microbadger_url))

        os.makedirs(debian_codename_dir)

        with open(debian_dockerfile_template, 'r') as dct:
            debian_dockerfile_template_content = dct.read()

        debian_dockerfile_content = debian_dockerfile_template_content
        debian_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                           base_image,
                                           debian_dockerfile_content)
        debian_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                           debian_codename,
                                           debian_dockerfile_content)

        with open(debian_dockerfile, 'w') as dd:
            dd.write(debian_dockerfile_content)

    with open(debian_readme_template, 'r') as drt:
        debian_readme_template_content = drt.read()

    debian_readme_table = '\n'.join(debian_readme_tablelist)

    debian_readme_content = debian_readme_template_content
    debian_readme_content = re.sub('%%DEBIAN_TABLE%%',
                                   debian_readme_table,
                                   debian_readme_content)

    with open(debian_readme, 'w') as dr:
        dr.write(debian_readme_content)

        return travis_matrixlist, debian_readme_table
