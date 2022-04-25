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

from .config import postgres_versions
from .utils import find_dirs
from .logger import logger


def update_postgres(basedir):

    matrix = []
    postgres_readme_tablelist = []
    postgresdir = os.path.join(basedir, 'postgres')
    postgres_dockerfile_template = os.path.join(postgresdir,
                                                'Dockerfile.template')
    postgres_readme_template = os.path.join(postgresdir, 'README.md.template')
    postgres_readme = os.path.join(postgresdir, 'README.md')
    postgres_hooks_dir = os.path.join(postgresdir, 'hooks')
    postgres_build_hook = os.path.join(postgres_hooks_dir, 'build')
    postgres_push_hook = os.path.join(postgres_hooks_dir, 'push')

    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/postgres:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/postgres'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-postgres%2F{0}%2FDockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&cacheSeconds=900'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/postgres/{0}/Dockerfile')
    pulls_badge_holder = ('https://img.shields.io/docker/pulls/dockershelf/postgres'
                          '?colorA=22313f&colorB=4a637b&cacheSeconds=900')
    pulls_url_holder = ('https://hub.docker.com/r/dockershelf/postgres')
    size_badge_holder = ('https://img.shields.io/docker/image-size/'
                         'dockershelf/postgres/{0}.svg'
                         '?colorA=22313f&colorB=4a637b&cacheSeconds=900')
    size_url_holder = ('https://hub.docker.com/r/dockershelf/postgres')
    matrix_latest_str = (
        '          - docker-image-name: "dockershelf/postgres:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/postgres:latest"')
    matrix_str = (
        '          - docker-image-name: "dockershelf/postgres:{0}"')
    postgres_readme_tablelist_holder = ('|[`{0}`]({1})'
                                        '|`{2}`'
                                        '|[![]({3})]({4})'
                                        '|[![]({5})]({6})'
                                        '|[![]({7})]({8})'
                                        '|')
    postgres_latest_version = postgres_versions[-1]

    logger.info('Erasing current Postgres folders')
    for deldir in find_dirs(postgresdir):
        shutil.rmtree(deldir)

    for postgres_version in postgres_versions:
        logger.info('Processing Postgres {0}'.format(postgres_version))
        postgres_version_dir = os.path.join(postgresdir, postgres_version)
        postgres_dockerfile = os.path.join(postgres_version_dir,
                                           'Dockerfile')
        docker_tag = docker_tag_holder.format(postgres_version)
        dockerfile_badge = dockerfile_badge_holder.format(postgres_version)
        dockerfile_url = dockerfile_url_holder.format(postgres_version)
        pulls_badge = pulls_badge_holder.format(postgres_version)
        pulls_url = pulls_url_holder.format(postgres_version)
        size_badge = size_badge_holder.format(postgres_version)
        size_url = size_url_holder.format(postgres_version)

        if postgres_version == postgres_latest_version:
            matrix.append(
                matrix_latest_str.format(postgres_version))
        else:
            matrix.append(
                matrix_str.format(postgres_version))

        postgres_readme_tablelist.append(
            postgres_readme_tablelist_holder.format(
                docker_tag, docker_url, postgres_version, dockerfile_badge,
                dockerfile_url, pulls_badge, pulls_url,
                size_badge, size_url))

        os.makedirs(postgres_version_dir)

        with open(postgres_dockerfile_template, 'r') as pdt:
            postgres_dockerfile_template_content = pdt.read()

        postgres_dockerfile_content = postgres_dockerfile_template_content
        postgres_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                             base_image,
                                             postgres_dockerfile_content)
        postgres_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                             'sid',
                                             postgres_dockerfile_content)
        postgres_dockerfile_content = re.sub('%%POSTGRES_VERSION%%',
                                             postgres_version,
                                             postgres_dockerfile_content)

        with open(postgres_dockerfile, 'w') as pd:
            pd.write(postgres_dockerfile_content)

    os.makedirs(postgres_hooks_dir)

    logger.info('Writing dummy hooks')
    with open(postgres_build_hook, 'w') as pbh:
        pbh.write('#!/usr/bin/env bash\n')
        pbh.write('echo "This is a dummy build script that just allows to '
                  'automatically fill the long description with the Readme '
                  'from GitHub."\n')
        pbh.write('echo "No real building is done here."')

    with open(postgres_push_hook, 'w') as pph:
        pph.write('#!/usr/bin/env bash\n')
        pph.write('echo "We arent really pushing."')

    logger.info('Writing Postgres Readme')
    with open(postgres_readme_template, 'r') as prt:
        postgres_readme_template_content = prt.read()

    postgres_readme_table = '\n'.join(postgres_readme_tablelist)

    postgres_readme_content = postgres_readme_template_content
    postgres_readme_content = re.sub('%%POSTGRES_TABLE%%',
                                     postgres_readme_table,
                                     postgres_readme_content)

    with open(postgres_readme, 'w') as pr:
        pr.write(postgres_readme_content)

    return matrix, postgres_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_postgres(basedir)
