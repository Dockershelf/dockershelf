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

from .config import debian_versions
from .utils import find_dirs
from .logger import logger


def update_debian(basedir):

    matrix = []
    debian_readme_tablelist = []
    debiandir = os.path.join(basedir, 'debian')
    debian_dockerfile_template = os.path.join(debiandir, 'Dockerfile.template')
    debian_readme_template = os.path.join(debiandir, 'README.md.template')
    debian_readme = os.path.join(debiandir, 'README.md')

    base_image = 'scratch'
    docker_tag_holder = 'dockershelf/debian:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/debian'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-Dockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&cacheSeconds=900'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/debian/{0}/Dockerfile')
    pulls_badge_holder = ('https://img.shields.io/docker/pulls/dockershelf/'
                          'debian?colorA=22313f&colorB=4a637b'
                          '&cacheSeconds=900')
    pulls_url_holder = ('https://hub.docker.com/r/dockershelf/debian')
    size_badge_holder = ('https://img.shields.io/docker/image-size/'
                         'dockershelf/debian/{0}.svg'
                         '?colorA=22313f&colorB=4a637b&cacheSeconds=900')
    size_url_holder = ('https://hub.docker.com/r/dockershelf/debian')
    matrix_str = (
        '          - docker-image-name: "dockershelf/debian:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/debian:{1}"'
        '\n            debian-suite: "{1}"')
    debian_readme_tablelist_holder = ('|[`{0}`]({1})'
                                      '|[![]({2})]({3})'
                                      '|[![]({4})]({5})'
                                      '|[![]({6})]({7})'
                                      '|')

    logger.info('Erasing current Debian folders')
    for deldir in find_dirs(debiandir):
        shutil.rmtree(deldir)

    for debian_version, debian_suite in debian_versions:
        logger.info('Processing Debian {0}'.format(debian_version))
        debian_version_dir = os.path.join(debiandir, debian_version)
        debian_dockerfile = os.path.join(debian_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(debian_version)
        dockerfile_badge = dockerfile_badge_holder.format(debian_version)
        dockerfile_url = dockerfile_url_holder.format(debian_version)
        pulls_badge = pulls_badge_holder.format(debian_version)
        pulls_url = pulls_url_holder.format(debian_version)
        size_badge = size_badge_holder.format(debian_version)
        size_url = size_url_holder.format(debian_version)

        matrix.append(matrix_str.format(
            debian_version, debian_suite))

        debian_readme_tablelist.append(
            debian_readme_tablelist_holder.format(
                docker_tag, docker_url, dockerfile_badge,
                dockerfile_url, pulls_badge, pulls_url,
                size_badge, size_url))

        os.makedirs(debian_version_dir)

        with open(debian_dockerfile_template, 'r') as dct:
            debian_dockerfile_template_content = dct.read()

        debian_dockerfile_content = debian_dockerfile_template_content
        debian_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                           base_image,
                                           debian_dockerfile_content)
        debian_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                           debian_version,
                                           debian_dockerfile_content)
        debian_dockerfile_content = re.sub('%%DEBIAN_SUITE%%',
                                           debian_suite,
                                           debian_dockerfile_content)

        with open(debian_dockerfile, 'w') as dd:
            dd.write(debian_dockerfile_content)

    logger.info('Writing Debian Readme')
    with open(debian_readme_template, 'r') as drt:
        debian_readme_template_content = drt.read()

    debian_readme_table = '\n'.join(debian_readme_tablelist)

    debian_readme_content = debian_readme_template_content
    debian_readme_content = re.sub('%%DEBIAN_TABLE%%',
                                   debian_readme_table,
                                   debian_readme_content)

    with open(debian_readme, 'w') as dr:
        dr.write(debian_readme_content)

        return matrix, debian_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_debian(basedir)
