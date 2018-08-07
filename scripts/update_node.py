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
import shutil
from contextlib import closing

try:
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen

from packaging.version import Version

from .utils import find_dirs, u
from .logger import logger

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
    node_hooks_dir = os.path.join(nodedir, 'hooks')
    node_build_hook = os.path.join(node_hooks_dir, 'build')
    node_push_hook = os.path.join(node_hooks_dir, 'push')

    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/node:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/node'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-node%2F{0}%2FDockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&maxAge=86400'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/node/{0}/Dockerfile')
    mb_layers_badge_holder = ('https://img.shields.io/microbadger/layers/'
                              'dockershelf/node/{0}.svg'
                              '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_layers_url_holder = ('https://microbadger.com/images/dockershelf/'
                            'node:{0}')
    mb_size_badge_holder = ('https://img.shields.io/microbadger/image-size/'
                            'dockershelf/node/{0}.svg'
                            '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_size_url_holder = ('https://microbadger.com/images/dockershelf/'
                          'node:{0}')
    travis_matrixlist_latest_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/node:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/node:latest"')
    travis_matrixlist_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/node:{0}"')
    node_readme_tablelist_holder = ('|[`{0}`]({1})'
                                    '|`{2}`'
                                    '|[![]({3})]({4})'
                                    '|[![]({5})]({6})'
                                    '|[![]({7})]({8})'
                                    '|')

    node_versions_list_file = ('https://raw.githubusercontent.com/nodesource/'
                               'distributions/master/deb/src/build.sh')
    node_version_lower_limit = 5
    node_version_upper_limit = 10

    logger.info('Getting Node versions')
    with closing(urlopen(node_versions_list_file)) as n:
        node_versions_list_content = n.read()

    node_versions = re.findall(r'node_(\d*)\.x:_\d*\.x:nodejs:Node\.js \d*\.x',
                               u(node_versions_list_content))
    node_versions = [v for v in node_versions
                     if (float(v) >= node_version_lower_limit and
                         float(v) <= node_version_upper_limit)]
    node_versions = sorted(set(node_versions), key=lambda x: Version(x))
    node_latest_version = node_versions[-1]

    logger.info('Erasing current Node folders')
    for deldir in find_dirs(nodedir):
        shutil.rmtree(deldir)

    for node_version in node_versions:
        logger.info('Processing Node {0}'.format(node_version))
        node_version_dir = os.path.join(nodedir, node_version)
        node_dockerfile = os.path.join(node_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(node_version)
        dockerfile_badge = dockerfile_badge_holder.format(node_version)
        dockerfile_url = dockerfile_url_holder.format(node_version)
        mb_layers_badge = mb_layers_badge_holder.format(node_version)
        mb_layers_url = mb_layers_url_holder.format(node_version)
        mb_size_badge = mb_size_badge_holder.format(node_version)
        mb_size_url = mb_size_url_holder.format(node_version)

        if node_version == node_latest_version:
            travis_matrixlist.append(
                travis_matrixlist_latest_str.format(node_version))
        else:
            travis_matrixlist.append(
                travis_matrixlist_str.format(node_version))

        node_readme_tablelist.append(
            node_readme_tablelist_holder.format(
                docker_tag, docker_url, node_version, dockerfile_badge,
                dockerfile_url, mb_layers_badge, mb_layers_url,
                mb_size_badge, mb_size_url))

        os.makedirs(node_version_dir)

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

    os.makedirs(node_hooks_dir)

    logger.info('Writing dummy hooks')
    with open(node_build_hook, 'w') as nbh:
        nbh.write('#!/usr/bin/env bash\n')
        nbh.write('echo "This is a dummy build script that just allows to '
                  'automatically fill the long description with the Readme '
                  'from GitHub."\n')
        nbh.write('echo "No real building is done here."')

    with open(node_push_hook, 'w') as nph:
        nph.write('#!/usr/bin/env bash\n')
        nph.write('echo "We arent really pushing."')

    logger.info('Writing Node Readme')
    with open(node_readme_template, 'r') as prt:
        node_readme_template_content = prt.read()

    node_readme_table = '\n'.join(node_readme_tablelist)

    node_readme_content = node_readme_template_content
    node_readme_content = re.sub('%%NODE_TABLE%%', node_readme_table,
                                 node_readme_content)

    with open(node_readme, 'w') as pr:
        pr.write(node_readme_content)

    return travis_matrixlist, node_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_node(basedir)
