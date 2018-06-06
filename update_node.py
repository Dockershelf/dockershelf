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
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen

from utils import find_dirs

if not sys.version_info < (3,):
    unicode = str
    basestring = str


def update_node(basedir):

    travis_matrixlist = []
    node_readme_tablelist = []
    nodedir = os.path.join(basedir, 'node')
    node_dockerfile_template = os.path.join(nodedir, 'Dockerfile.template')
    node_readme_template = os.path.join(nodedir, 'README.md.template')
    node_readme = os.path.join(nodedir, 'README.md')
    node_versions_list_file = ('https://raw.githubusercontent.com/nodesource/'
                               'distributions/master/deb/src/build.sh')

    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/node:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/node'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-node%2F{0}%2FDockerfile-blue.svg')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/node/{0}/Dockerfile')
    microbadger_badge_holder = ('https://images.microbadger.com/badges/'
                                'image/dockershelf/node:{0}.svg')
    microbadger_url_holder = ('https://microbadger.com/images/'
                              'dockershelf/node:{0}')
    travis_matrixlist_str = ('        '
                             '- DOCKER_IMAGE_NAME="dockershelf/node:{0}"')
    latex_readme_tablelist_holder = ('|[`{0}`]({1})'
                                     '|`{2}`'
                                     '|[![]({3})]({4})'
                                     '|[![]({5})]({6})|')

    with closing(urlopen(node_versions_list_file)) as n:
        node_versions = set(re.findall(
            r'node_(\d*)\.x:_\d*\.x:nodejs:Node\.js \d*\.x', n.read()))

    for deldir in find_dirs(nodedir):
        shutil.rmtree(deldir)

    for node_version in node_versions:
        node_os_version_dir = os.path.join(nodedir, node_version)
        node_dockerfile = os.path.join(node_os_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(node_version)
        dockerfile_badge = dockerfile_badge_holder.format(node_version)
        dockerfile_url = dockerfile_url_holder.format(node_version)
        microbadger_badge = microbadger_badge_holder.format(node_version)
        microbadger_url = microbadger_url_holder.format(node_version)

        travis_matrixlist.append(travis_matrixlist_str.format(node_version))

        node_readme_tablelist.append(latex_readme_tablelist_holder.format(
            docker_tag, docker_url, node_version, dockerfile_badge,
            dockerfile_url, microbadger_badge, microbadger_url))

        os.makedirs(node_os_version_dir)

        with open(node_dockerfile_template, 'r') as pdt:
            node_dockerfile_template_content = pdt.read()

        node_dockerfile_content = node_dockerfile_template_content
        node_dockerfile_content = re.sub('%%BASE_IMAGE%%', base_image,
                                         node_dockerfile_content)
        node_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%', 'sid',
                                         node_dockerfile_content)
        node_dockerfile_content = re.sub('%%NODE_VERSION%%', node_version,
                                         node_dockerfile_content)

        with open(node_dockerfile, 'w') as pd:
            pd.write(node_dockerfile_content)

    with open(node_readme_template, 'r') as prt:
        node_readme_template_content = prt.read()

    node_readme_table = '\n'.join(node_readme_tablelist)

    node_readme_content = node_readme_template_content
    node_readme_content = re.sub('%%NODE_TABLE%%', node_readme_table,
                                 node_readme_content)

    with open(node_readme, 'w') as pr:
        pr.write(node_readme_content)

    return travis_matrixlist, node_readme_table
