#!/usr/bin/env php3
# -*- coding: utf-8 -*-
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-2020, Dockershelf Developers.
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

from .config import php_versions, php_versions_src_origin
from .utils import find_dirs
from .logger import logger


def update_php(basedir):

    matrix = []
    php_readme_tablelist = []
    phpdir = os.path.join(basedir, 'php')
    php_dockerfile_template = os.path.join(phpdir, 'Dockerfile.template')
    php_readme_template = os.path.join(phpdir, 'README.md.template')
    php_readme = os.path.join(phpdir, 'README.md')
    php_hooks_dir = os.path.join(phpdir, 'hooks')
    php_build_hook = os.path.join(php_hooks_dir, 'build')
    php_push_hook = os.path.join(php_hooks_dir, 'push')

    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/php:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/php'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-php%2F{0}%2FDockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&cacheSeconds=120'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/php/{0}/Dockerfile')
    mb_layers_badge_holder = ('https://img.shields.io/microbadger/layers/'
                              'dockershelf/php/{0}.svg'
                              '?colorA=22313f&colorB=4a637b&cacheSeconds=120')
    mb_layers_url_holder = ('https://microbadger.com/images/dockershelf/'
                            'php:{0}')
    mb_size_badge_holder = ('https://img.shields.io/docker/image-size/'
                            'dockershelf/php/{0}.svg'
                            '?colorA=22313f&colorB=4a637b&cacheSeconds=120')
    mb_size_url_holder = ('https://microbadger.com/images/dockershelf/'
                          'php:{0}')
    matrix_latest_str = (
        '          - docker-image-name: "dockershelf/php:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/php:latest"')
    matrix_str = (
        '          - docker-image-name: "dockershelf/php:{0}"')
    php_readme_tablelist_holder = ('|[`{0}`]({1})'
                                   '|`{2}`'
                                   '|[![]({3})]({4})'
                                   '|[![]({5})]({6})'
                                   '|[![]({7})]({8})'
                                   '|')
    php_latest_version = php_versions[-1]

    logger.info('Erasing current PHP folders')
    for deldir in find_dirs(phpdir):
        shutil.rmtree(deldir)

    for php_version in php_versions:
        logger.info('Processing PHP {0}'.format(php_version))
        php_version_dir = os.path.join(phpdir, php_version)
        php_dockerfile = os.path.join(php_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(php_version)
        dockerfile_badge = dockerfile_badge_holder.format(php_version)
        dockerfile_url = dockerfile_url_holder.format(php_version)
        mb_layers_badge = mb_layers_badge_holder.format(php_version)
        mb_layers_url = mb_layers_url_holder.format(php_version)
        mb_size_badge = mb_size_badge_holder.format(php_version)
        mb_size_url = mb_size_url_holder.format(php_version)

        if php_version == php_latest_version:
            matrix.append(
                matrix_latest_str.format(php_version))
        else:
            matrix.append(
                matrix_str.format(php_version))

        php_readme_tablelist.append(
            php_readme_tablelist_holder.format(
                docker_tag, docker_url, php_version, dockerfile_badge,
                dockerfile_url, mb_layers_badge, mb_layers_url,
                mb_size_badge, mb_size_url))

        os.makedirs(php_version_dir)

        with open(php_dockerfile_template, 'r') as pdt:
            php_dockerfile_template_content = pdt.read()

        php_dockerfile_content = php_dockerfile_template_content
        php_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                        base_image,
                                        php_dockerfile_content)
        php_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                        'sid',
                                        php_dockerfile_content)
        php_dockerfile_content = re.sub('%%PHP_VERSION%%',
                                        php_version,
                                        php_dockerfile_content)
        php_dockerfile_content = re.sub('%%PHP_DEBIAN_SUITE%%',
                                        php_versions_src_origin[php_version],
                                        php_dockerfile_content)

        with open(php_dockerfile, 'w') as pd:
            pd.write(php_dockerfile_content)

    os.makedirs(php_hooks_dir)

    logger.info('Writing dummy hooks')
    with open(php_build_hook, 'w') as pbh:
        pbh.write('#!/usr/bin/env bash\n')
        pbh.write('echo "This is a dummy build script that just allows to '
                  'automatically fill the long description with the Readme '
                  'from GitHub."\n')
        pbh.write('echo "No real building is done here."')

    logger.info('Writing PHP Readme')
    with open(php_push_hook, 'w') as pph:
        pph.write('#!/usr/bin/env bash\n')
        pph.write('echo "We arent really pushing."')

    with open(php_readme_template, 'r') as prt:
        php_readme_template_content = prt.read()

    php_readme_table = '\n'.join(php_readme_tablelist)

    php_readme_content = php_readme_template_content
    php_readme_content = re.sub('%%PHP_TABLE%%',
                                php_readme_table,
                                php_readme_content)

    with open(php_readme, 'w') as pr:
        pr.write(php_readme_content)

    return matrix, php_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_php(basedir)
