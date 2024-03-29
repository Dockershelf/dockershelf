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

from .config import go_versions, debian_versions
from .utils import find_dirs
from .logger import logger


def update_go(basedir):

    matrix = []
    tag_matrix = []
    go_readme_tablelist = []
    godir = os.path.join(basedir, 'go')
    go_dockerfile_template = os.path.join(godir, 'Dockerfile.template')
    go_readme_template = os.path.join(godir, 'README.md.template')
    go_readme = os.path.join(godir, 'README.md')

    debian_versions_eq = {v: k for k, v in debian_versions}

    base_image = 'dockershelf/debian:{0}'
    docker_tag_holder = 'dockershelf/go:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/go'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-Dockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/go/{0}/Dockerfile')
    pulls_badge_holder = ('https://img.shields.io/docker/pulls/dockershelf/'
                          'go?colorA=22313f&colorB=4a637b'
                          '')
    pulls_url_holder = ('https://hub.docker.com/r/dockershelf/go')
    size_badge_holder = ('https://img.shields.io/docker/image-size/'
                         'dockershelf/go/{0}.svg'
                         '?colorA=22313f&colorB=4a637b')
    size_url_holder = ('https://hub.docker.com/r/dockershelf/go')
    matrix_str = (
        '          - docker-image-name: "dockershelf/go:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/go:{1}"')
    matrix_str_main = (
        '          - docker-image-name: "dockershelf/go:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/go:{1} '
        'dockershelf/go:{2}"')
    matrix_str_latest_stable = (
        '          - docker-image-name: "dockershelf/go:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/go:{1} '
        'dockershelf/go:{2} dockershelf/go:{3}"')
    matrix_str_latest_unstable = (
        '          - docker-image-name: "dockershelf/go:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/go:{1} '
        'dockershelf/go:{2} dockershelf/go:{3} dockershelf/go:{4} '
        'dockershelf/go:{5}"')
    go_readme_tablelist_holder = ('|[`{0}`]({1})'
                                  '|[![]({2})]({3})'
                                  '|[![]({4})]({5})'
                                  '|[![]({6})]({7})'
                                  '|')

    latest_version = go_versions[-1]
    latest_major_version = 'latest'

    logger.info('Erasing current Go folders')
    for deldir in find_dirs(godir):
        shutil.rmtree(deldir)

    for go_version_long in go_versions:
        go_version_short = '.'.join(go_version_long.split('.')[:2])
        for debian_version in [debian_versions_eq['stable'],
                               debian_versions_eq['unstable']]:
            logger.info('Processing Go {0} ({1})'.format(
                go_version_short, debian_version))
            go_version = '{0}-{1}'.format(go_version_short, debian_version)
            go_version_stable = '{0}-{1}'.format(go_version_short, 'stable')
            go_version_unstable = '{0}-{1}'.format(go_version_short, 'unstable')
            go_version_dir = os.path.join(godir, go_version)
            go_dockerfile = os.path.join(go_version_dir, 'Dockerfile')

            docker_tag = docker_tag_holder.format(go_version)
            dockerfile_badge = dockerfile_badge_holder.format(
                go_version_short, debian_version)
            dockerfile_url = dockerfile_url_holder.format(go_version)
            pulls_badge = pulls_badge_holder.format(go_version)
            pulls_url = pulls_url_holder.format(go_version)
            size_badge = size_badge_holder.format(go_version)
            size_url = size_url_holder.format(go_version)

            if go_version_long == latest_version:
                if debian_version == 'sid':
                    matrix.append(matrix_str_latest_unstable.format(
                        go_version, go_version_unstable, go_version_short,
                        f'{latest_major_version}-unstable', f'{latest_major_version}-sid', latest_major_version))
                    tag_matrix.extend([
                        go_version, go_version_unstable, go_version_short,
                        f'{latest_major_version}-unstable', f'{latest_major_version}-sid', latest_major_version])
                else:
                    matrix.append(matrix_str_latest_stable.format(
                        go_version, go_version_stable,
                        f'{latest_major_version}-stable', f'{latest_major_version}-{debian_version}'))
                    tag_matrix.extend([
                        go_version, go_version_stable,
                        f'{latest_major_version}-stable', f'{latest_major_version}-{debian_version}'])
            else:
                if debian_version == 'sid':
                    matrix.append(matrix_str_main.format(go_version, go_version_unstable, go_version_short))
                    tag_matrix.extend([go_version, go_version_unstable, go_version_short])
                else:
                    matrix.append(matrix_str.format(go_version, go_version_stable))
                    tag_matrix.extend([go_version, go_version_stable])

            go_readme_tablelist.append(
                go_readme_tablelist_holder.format(
                    docker_tag, docker_url, dockerfile_badge,
                    dockerfile_url, pulls_badge, pulls_url,
                    size_badge, size_url))

            os.makedirs(go_version_dir)

            with open(go_dockerfile_template, 'r') as pdt:
                go_dockerfile_template_content = pdt.read()

            go_dockerfile_content = go_dockerfile_template_content
            go_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                           base_image.format(
                                               debian_version),
                                           go_dockerfile_content)
            go_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                           debian_version,
                                           go_dockerfile_content)
            go_dockerfile_content = re.sub('%%GO_VERSION%%',
                                           go_version_long,
                                           go_dockerfile_content)
            go_dockerfile_content = re.sub('%%GO_DEBIAN_SUITE%%',
                                           debian_version,
                                           go_dockerfile_content)

            with open(go_dockerfile, 'w') as pd:
                pd.write(go_dockerfile_content)

    with open(go_readme_template, 'r') as prt:
        go_readme_template_content = prt.read()

    go_readme_table = '\n'.join(go_readme_tablelist)
    go_readme_table_tags = '|[dockershelf/go](#go)|{0}|'.format(', '.join([f'`{tag}`' for tag in tag_matrix]))

    go_readme_content = re.sub('%%GO_TABLE%%',
                               go_readme_table,
                               go_readme_template_content)

    with open(go_readme, 'w') as pr:
        pr.write(go_readme_content)

    return matrix, go_readme_table, go_readme_table_tags


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_go(basedir)
