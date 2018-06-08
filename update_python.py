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

from utils import find_dirs

if not sys.version_info < (3,):
    unicode = str
    basestring = str


def update_python(basedir):

    travis_matrixlist = []
    python_versions = []
    python_readme_tablelist = []
    pythondir = os.path.join(basedir, 'python')
    python_dockerfile_template = os.path.join(pythondir, 'Dockerfile.template')
    python_readme_template = os.path.join(pythondir, 'README.md.template')
    python_readme = os.path.join(pythondir, 'README.md')

    base_image = 'dockershelf/debian:sid'
    docker_url = 'https://hub.docker.com/r/dockershelf/python'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-python%2F{0}%2FDockerfile-blue.svg')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/python/{0}/Dockerfile')
    microbadger_badge_holder = ('https://images.microbadger.com/badges/'
                                'image/dockershelf/python:{0}.svg')
    microbadger_url_holder = ('https://microbadger.com/images/'
                              'dockershelf/python:{0}')
    travis_matrixlist_py2_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/python:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/python:2"')
    travis_matrixlist_py3_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/python:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/python:3"')
    travis_matrixlist_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/python:{0}"')
    python_readme_tablelist_holder = ('|[`{0}`]({1})'
                                      '|`{2}`'
                                      '|[![]({3})]({4})'
                                      '|[![]({5})]({6})|')

    python_versions_src_origin = {
        '2.6': 'wheezy-security',
        '2.7': 'sid',
        '3.2': 'wheezy-security',
        '3.4': 'jessie',
        '3.5': 'sid',
        '3.6': 'sid',
        # '3.7': 'sid',
    }
    python_versions = sorted(python_versions_src_origin.keys())

    for deldir in find_dirs(pythondir):
        shutil.rmtree(deldir)

    for python_version in python_versions:
        python_os_version_dir = os.path.join(pythondir, python_version)
        python_dockerfile = os.path.join(python_os_version_dir, 'Dockerfile')
        dockerfile_badge = dockerfile_badge_holder.format(python_version)
        dockerfile_url = dockerfile_url_holder.format(python_version)
        microbadger_badge = microbadger_badge_holder.format(python_version)
        microbadger_url = microbadger_url_holder.format(python_version)

        if python_version == '2.7':
            travis_matrixlist.append(
                travis_matrixlist_py2_str.format(python_version))
        elif python_version == '3.5':
            travis_matrixlist.append(
                travis_matrixlist_py3_str.format(python_version))
        else:
            travis_matrixlist.append(
                travis_matrixlist_str.format(python_version))

        python_readme_tablelist.append(
            python_readme_tablelist_holder.format(
                python_version, docker_url, python_version,
                dockerfile_badge, dockerfile_url, microbadger_badge,
                microbadger_url))

        os.makedirs(python_os_version_dir)

        with open(python_dockerfile_template, 'r') as pdt:
            python_dockerfile_template_content = pdt.read()

        python_dockerfile_content = python_dockerfile_template_content
        python_dockerfile_content = re.sub(
            '%%BASE_IMAGE%%', base_image, python_dockerfile_content)
        python_dockerfile_content = re.sub(
            '%%DEBIAN_RELEASE%%', 'sid', python_dockerfile_content)
        python_dockerfile_content = re.sub(
            '%%PYTHON_VERSION%%', python_version, python_dockerfile_content)
        python_dockerfile_content = re.sub(
            '%%PYTHON_DEBIAN_SUITE%%',
            python_versions_src_origin[python_version],
            python_dockerfile_content)

        with open(python_dockerfile, 'w') as pd:
            pd.write(python_dockerfile_content)

    with open(python_readme_template, 'r') as prt:
        python_readme_template_content = prt.read()

    python_readme_table = '\n'.join(python_readme_tablelist)

    python_readme_content = python_readme_template_content
    python_readme_content = re.sub('%%PYTHON_TABLE%%', python_readme_table,
                                   python_readme_content)

    with open(python_readme, 'w') as pr:
        pr.write(python_readme_content)

    return travis_matrixlist, python_readme_table
