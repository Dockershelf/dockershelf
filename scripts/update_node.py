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
import shutil

from .config import node_versions, debian_versions
from .utils import find_dirs
from .logger import logger


def update_node(basedir):

    matrix = []
    node_readme_tablelist = []
    nodedir = os.path.join(basedir, 'node')
    node_dockerfile_template = os.path.join(nodedir, 'Dockerfile.template')
    node_readme_template = os.path.join(nodedir, 'README.md.template')
    node_readme = os.path.join(nodedir, 'README.md')
    node_hooks_dir = os.path.join(nodedir, 'hooks')
    node_build_hook = os.path.join(node_hooks_dir, 'build')
    node_push_hook = os.path.join(node_hooks_dir, 'push')

    debian_versions_eq = {v: k for k, v in debian_versions}

    base_image = 'dockershelf/debian:{0}'
    docker_tag_holder = 'dockershelf/node:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/node'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-node%2F{0}%2FDockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&cacheSeconds=900'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/node/{0}/Dockerfile')
    pulls_badge_holder = ('https://img.shields.io/docker/pulls/dockershelf/'
                          'node?colorA=22313f&colorB=4a637b'
                          '&cacheSeconds=900')
    pulls_url_holder = ('https://hub.docker.com/r/dockershelf/node')
    size_badge_holder = ('https://img.shields.io/docker/image-size/'
                         'dockershelf/node/{0}.svg'
                         '?colorA=22313f&colorB=4a637b&cacheSeconds=900')
    size_url_holder = ('https://hub.docker.com/r/dockershelf/node')
    matrix_str = (
        '          - docker-image-name: "dockershelf/node:{0}"')
    node_readme_tablelist_holder = ('|[`{0}`]({1})'
                                    '|`{2}`'
                                    '|[![]({3})]({4})'
                                    '|[![]({5})]({6})'
                                    '|[![]({7})]({8})'
                                    '|')

    logger.info('Erasing current Node folders')
    for deldir in find_dirs(nodedir):
        shutil.rmtree(deldir)

    for nodever in node_versions:
        for debian_version in [debian_versions_eq['stable'],
                               debian_versions_eq['unstable']]:
            logger.info('Processing Node {0} ({1})'.format(
                nodever, debian_version))
            node_version = '{0}-{1}'.format(nodever, debian_version)
            node_version_dir = os.path.join(nodedir, node_version)
            node_dockerfile = os.path.join(node_version_dir, 'Dockerfile')

            docker_tag = docker_tag_holder.format(node_version)
            dockerfile_badge = dockerfile_badge_holder.format(node_version)
            dockerfile_url = dockerfile_url_holder.format(node_version)
            pulls_badge = pulls_badge_holder.format(node_version)
            pulls_url = pulls_url_holder.format(node_version)
            size_badge = size_badge_holder.format(node_version)
            size_url = size_url_holder.format(node_version)

            matrix.append(matrix_str.format(node_version))

            node_readme_tablelist.append(
                node_readme_tablelist_holder.format(
                    docker_tag, docker_url, node_version, dockerfile_badge,
                    dockerfile_url, pulls_badge, pulls_url,
                    size_badge, size_url))

            os.makedirs(node_version_dir)

            with open(node_dockerfile_template, 'r') as pdt:
                node_dockerfile_template_content = pdt.read()

            node_dockerfile_content = node_dockerfile_template_content
            node_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                             base_image.format(debian_version),
                                             node_dockerfile_content)
            node_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                             debian_version,
                                             node_dockerfile_content)
            node_dockerfile_content = re.sub('%%NODE_VERSION%%',
                                             nodever,
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
    node_readme_content = re.sub('%%NODE_TABLE%%',
                                 node_readme_table,
                                 node_readme_content)

    with open(node_readme, 'w') as pr:
        pr.write(node_readme_content)

    return matrix, node_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_node(basedir)
