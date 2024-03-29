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

import os
import re
import shutil

from .config import node_versions, debian_versions
from .utils import find_dirs
from .logger import logger


def update_node(basedir):

    matrix = []
    tag_matrix = []
    node_readme_tablelist = []
    nodedir = os.path.join(basedir, 'node')
    node_dockerfile_template = os.path.join(nodedir, 'Dockerfile.template')
    node_readme_template = os.path.join(nodedir, 'README.md.template')
    node_readme = os.path.join(nodedir, 'README.md')

    debian_versions_eq = {v: k for k, v in debian_versions}

    base_image = 'dockershelf/debian:{0}'
    docker_tag_holder = 'dockershelf/node:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/node'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-Dockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/node/{0}/Dockerfile')
    pulls_badge_holder = ('https://img.shields.io/docker/pulls/dockershelf/'
                          'node?colorA=22313f&colorB=4a637b'
                          '')
    pulls_url_holder = ('https://hub.docker.com/r/dockershelf/node')
    size_badge_holder = ('https://img.shields.io/docker/image-size/'
                         'dockershelf/node/{0}.svg'
                         '?colorA=22313f&colorB=4a637b')
    size_url_holder = ('https://hub.docker.com/r/dockershelf/node')
    matrix_str = (
        '          - docker-image-name: "dockershelf/node:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/node:{1}"')
    matrix_str_main = (
        '          - docker-image-name: "dockershelf/node:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/node:{1} '
        'dockershelf/node:{2}"')
    matrix_str_latest_stable = (
        '          - docker-image-name: "dockershelf/node:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/node:{1} '
        'dockershelf/node:{2} dockershelf/node:{3}"')
    matrix_str_latest_unstable = (
        '          - docker-image-name: "dockershelf/node:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/node:{1} '
        'dockershelf/node:{2} dockershelf/node:{3} dockershelf/node:{4} '
        'dockershelf/node:{5}"')
    node_readme_tablelist_holder = ('|[`{0}`]({1})'
                                    '|[![]({2})]({3})'
                                    '|[![]({4})]({5})'
                                    '|[![]({6})]({7})'
                                    '|')

    latest_version = node_versions[-1]
    latest_major_version = 'latest'

    logger.info('Erasing current Node folders')
    for deldir in find_dirs(nodedir):
        shutil.rmtree(deldir)

    for node_version_long in node_versions:
        for debian_version in [debian_versions_eq['stable'],
                               debian_versions_eq['unstable']]:
            logger.info('Processing Node {0} ({1})'.format(
                node_version_long, debian_version))
            node_version = '{0}-{1}'.format(node_version_long, debian_version)
            node_version_stable = '{0}-{1}'.format(node_version_long, 'stable')
            node_version_unstable = '{0}-{1}'.format(node_version_long, 'unstable')
            node_version_dir = os.path.join(nodedir, node_version)
            node_dockerfile = os.path.join(node_version_dir, 'Dockerfile')

            docker_tag = docker_tag_holder.format(node_version)
            dockerfile_badge = dockerfile_badge_holder.format(
                node_version_long, debian_version)
            dockerfile_url = dockerfile_url_holder.format(node_version)
            pulls_badge = pulls_badge_holder.format(node_version)
            pulls_url = pulls_url_holder.format(node_version)
            size_badge = size_badge_holder.format(node_version)
            size_url = size_url_holder.format(node_version)

            if node_version_long == latest_version:
                if debian_version == 'sid':
                    matrix.append(matrix_str_latest_unstable.format(
                        node_version, node_version_unstable, node_version_long,
                        f'{latest_major_version}-unstable', f'{latest_major_version}-sid', latest_major_version))
                    tag_matrix.extend([
                        node_version, node_version_unstable, node_version_long,
                        f'{latest_major_version}-unstable', f'{latest_major_version}-sid', latest_major_version])
                else:
                    matrix.append(matrix_str_latest_stable.format(
                        node_version, node_version_stable,
                        f'{latest_major_version}-stable', f'{latest_major_version}-{debian_version}'))
                    tag_matrix.extend([
                        node_version, node_version_stable,
                        f'{latest_major_version}-stable', f'{latest_major_version}-{debian_version}'])
            else:
                if debian_version == 'sid':
                    matrix.append(matrix_str_main.format(node_version, node_version_unstable, node_version_long))
                    tag_matrix.extend([node_version, node_version_unstable, node_version_long])
                else:
                    matrix.append(matrix_str.format(node_version, node_version_stable))
                    tag_matrix.extend([node_version, node_version_stable])

            node_readme_tablelist.append(
                node_readme_tablelist_holder.format(
                    docker_tag, docker_url, dockerfile_badge,
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
                                             node_version_long,
                                             node_dockerfile_content)

            with open(node_dockerfile, 'w') as pd:
                pd.write(node_dockerfile_content)

    logger.info('Writing Node Readme')
    with open(node_readme_template, 'r') as prt:
        node_readme_template_content = prt.read()

    node_readme_table = '\n'.join(node_readme_tablelist)
    node_readme_table_tags = '|[dockershelf/node](#node)|{0}|'.format(', '.join([f'`{tag}`' for tag in tag_matrix]))

    node_readme_content = re.sub('%%NODE_TABLE%%',
                                 node_readme_table,
                                 node_readme_template_content)

    with open(node_readme, 'w') as pr:
        pr.write(node_readme_content)

    return matrix, node_readme_table, node_readme_table_tags


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_node(basedir)
