#!/usr/bin/env python3
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

from .config import python_versions, python_versions_src_origin
from .utils import find_dirs
from .logger import logger


def update_python(basedir):

    matrix = []
    python_readme_tablelist = []
    pythondir = os.path.join(basedir, 'python')
    python_dockerfile_template = os.path.join(pythondir, 'Dockerfile.template')
    python_readme_template = os.path.join(pythondir, 'README.md.template')
    python_readme = os.path.join(pythondir, 'README.md')
    python_hooks_dir = os.path.join(pythondir, 'hooks')
    python_build_hook = os.path.join(python_hooks_dir, 'build')
    python_push_hook = os.path.join(python_hooks_dir, 'push')

    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/python:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/python'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-python%2F{0}%2FDockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&cacheSeconds=900'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/python/{0}/Dockerfile')
    pulls_badge_holder = ('https://img.shields.io/docker/pulls/dockershelf/python'
                          '?colorA=22313f&colorB=4a637b&cacheSeconds=900')
    pulls_url_holder = ('https://hub.docker.com/r/dockershelf/python')
    size_badge_holder = ('https://img.shields.io/docker/image-size/'
                         'dockershelf/python/{0}.svg'
                         '?colorA=22313f&colorB=4a637b&cacheSeconds=900')
    size_url_holder = ('https://hub.docker.com/r/dockershelf/python')
    matrix_latest_str = (
        '          - docker-image-name: "dockershelf/python:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/python:latest"')
    matrix_py3_str = (
        '          - docker-image-name: "dockershelf/python:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/python:3"')
    matrix_str = (
        '          - docker-image-name: "dockershelf/python:{0}"')
    python_readme_tablelist_holder = ('|[`{0}`]({1})'
                                      '|`{2}`'
                                      '|[![]({3})]({4})'
                                      '|[![]({5})]({6})'
                                      '|[![]({7})]({8})'
                                      '|')
    python_latest_version = python_versions[-1]

    logger.info('Erasing current Python folders')
    for deldir in find_dirs(pythondir):
        shutil.rmtree(deldir)

    for python_version in python_versions:
        logger.info('Processing Python {0}'.format(python_version))
        python_version_dir = os.path.join(pythondir, python_version)
        python_dockerfile = os.path.join(python_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(python_version)
        dockerfile_badge = dockerfile_badge_holder.format(python_version)
        dockerfile_url = dockerfile_url_holder.format(python_version)
        pulls_badge = pulls_badge_holder.format(python_version)
        pulls_url = pulls_url_holder.format(python_version)
        size_badge = size_badge_holder.format(python_version)
        size_url = size_url_holder.format(python_version)

        if python_version == '3.9':
            matrix.append(
                matrix_py3_str.format(python_version))
        elif python_version == python_latest_version:
            matrix.append(
                matrix_latest_str.format(python_version))
        else:
            matrix.append(
                matrix_str.format(python_version))

        python_readme_tablelist.append(
            python_readme_tablelist_holder.format(
                docker_tag, docker_url, python_version, dockerfile_badge,
                dockerfile_url, pulls_badge, pulls_url,
                size_badge, size_url))

        os.makedirs(python_version_dir)

        with open(python_dockerfile_template, 'r') as pdt:
            python_dockerfile_template_content = pdt.read()

        python_dockerfile_content = python_dockerfile_template_content
        python_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                           base_image,
                                           python_dockerfile_content)
        python_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                           'sid',
                                           python_dockerfile_content)
        python_dockerfile_content = re.sub('%%PYTHON_VERSION%%',
                                           python_version,
                                           python_dockerfile_content)
        python_dockerfile_content = re.sub('%%PYTHON_DEBIAN_SUITE%%',
                                           python_versions_src_origin[python_version],
                                           python_dockerfile_content)

        with open(python_dockerfile, 'w') as pd:
            pd.write(python_dockerfile_content)

    os.makedirs(python_hooks_dir)

    logger.info('Writing dummy hooks')
    with open(python_build_hook, 'w') as pbh:
        pbh.write('#!/usr/bin/env bash\n')
        pbh.write('echo "This is a dummy build script that just allows to '
                  'automatically fill the long description with the Readme '
                  'from GitHub."\n')
        pbh.write('echo "No real building is done here."')

    logger.info('Writing Python Readme')
    with open(python_push_hook, 'w') as pph:
        pph.write('#!/usr/bin/env bash\n')
        pph.write('echo "We arent really pushing."')

    with open(python_readme_template, 'r') as prt:
        python_readme_template_content = prt.read()

    python_readme_table = '\n'.join(python_readme_tablelist)

    python_readme_content = python_readme_template_content
    python_readme_content = re.sub('%%PYTHON_TABLE%%',
                                   python_readme_table,
                                   python_readme_content)

    with open(python_readme, 'w') as pr:
        pr.write(python_readme_content)

    return matrix, python_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_python(basedir)
