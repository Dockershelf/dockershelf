#!/usr/bin/env python3
# -*- coding: utf-8 -*-
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
import shutil

from .config import debian_versions
from .utils import find_dirs
from .logger import logger


def update_debian(basedir):

    travis_matrixlist = []
    debian_readme_tablelist = []
    debiandir = os.path.join(basedir, 'debian')
    debian_dockerfile_template = os.path.join(debiandir, 'Dockerfile.template')
    debian_readme_template = os.path.join(debiandir, 'README.md.template')
    debian_readme = os.path.join(debiandir, 'README.md')
    debian_hooks_dir = os.path.join(debiandir, 'hooks')
    debian_build_hook = os.path.join(debian_hooks_dir, 'build')
    debian_push_hook = os.path.join(debian_hooks_dir, 'push')

    base_image = 'scratch'
    docker_tag_holder = 'dockershelf/debian:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/debian'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-debian%2F{0}%2FDockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&maxAge=86400'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/debian/{0}/Dockerfile')
    mb_layers_badge_holder = ('https://img.shields.io/microbadger/layers/'
                              'dockershelf/debian/{0}.svg'
                              '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_layers_url_holder = ('https://microbadger.com/images/dockershelf/'
                            'debian:{0}')
    mb_size_badge_holder = ('https://img.shields.io/microbadger/image-size/'
                            'dockershelf/debian/{0}.svg'
                            '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_size_url_holder = ('https://microbadger.com/images/dockershelf/'
                          'debian:{0}')
    travis_matrixlist_latest_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/debian:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/debian:{1} '
        'dockershelf/debian:latest"')
    travis_matrixlist_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/debian:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/debian:{1}"')
    debian_readme_tablelist_holder = ('|[`{0}`]({1})'
                                      '|`{2}`'
                                      '|[![]({3})]({4})'
                                      '|[![]({5})]({6})'
                                      '|[![]({7})]({8})'
                                      '|')
    debian_latest_version = debian_versions[-1][0]

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
        mb_layers_badge = mb_layers_badge_holder.format(debian_version)
        mb_layers_url = mb_layers_url_holder.format(debian_version)
        mb_size_badge = mb_size_badge_holder.format(debian_version)
        mb_size_url = mb_size_url_holder.format(debian_version)

        if debian_version == debian_latest_version:
            travis_matrixlist.append(travis_matrixlist_latest_str.format(
                debian_version, debian_suite))
        else:
            travis_matrixlist.append(travis_matrixlist_str.format(
                debian_version, debian_suite))

        debian_readme_tablelist.append(
            debian_readme_tablelist_holder.format(
                docker_tag, docker_url, debian_version, dockerfile_badge,
                dockerfile_url, mb_layers_badge, mb_layers_url,
                mb_size_badge, mb_size_url))

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

        with open(debian_dockerfile, 'w') as dd:
            dd.write(debian_dockerfile_content)

    logger.info('Writing dummy hooks')
    os.makedirs(debian_hooks_dir)

    with open(debian_build_hook, 'w') as pbh:
        pbh.write('#!/usr/bin/env bash\n')
        pbh.write('echo "This is a dummy build script that just allows to '
                  'automatically fill the long description with the Readme '
                  'from GitHub."\n')
        pbh.write('echo "No real building is done here."')

    with open(debian_push_hook, 'w') as pph:
        pph.write('#!/usr/bin/env bash\n')
        pph.write('echo "We arent really pushing."')

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

        return travis_matrixlist, debian_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_debian(basedir)
