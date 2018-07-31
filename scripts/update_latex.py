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

from .utils import find_dirs

if not sys.version_info < (3,):
    unicode = str
    basestring = str


def update_latex(basedir):

    travis_matrixlist = []
    latex_readme_tablelist = []
    latexdir = os.path.join(basedir, 'latex')
    latex_dockerfile_template = os.path.join(latexdir, 'Dockerfile.template')
    latex_readme_template = os.path.join(latexdir, 'README.md.template')
    latex_readme = os.path.join(latexdir, 'README.md')

    base_image = 'dockershelf/debian:sid'
    docker_tag = 'dockershelf/latex:sid'
    docker_url = 'https://hub.docker.com/r/dockershelf/latex'
    dockerfile_badge = ('https://img.shields.io/badge/'
                        '-latex%2Fsid%2FDockerfile-blue.svg')
    dockerfile_url = ('https://github.com/LuisAlejandro/dockershelf/'
                      'blob/master/latex/sid/Dockerfile')
    microbadger_badge = ('https://images.microbadger.com/badges/'
                         'image/dockershelf/latex:sid.svg')
    microbadger_url = 'https://microbadger.com/images/dockershelf/latex:sid'
    travis_matrixlist_str = ('        '
                             '- DOCKER_IMAGE_NAME="dockershelf/latex:sid"')
    latex_readme_tablelist_holder = ('|[`{0}`]({1})'
                                     '|`{2}`'
                                     '|[![]({3})]({4})'
                                     '|[![]({5})]({6})|')

    for deldir in find_dirs(latexdir):
        shutil.rmtree(deldir)

    latex_os_version_dir = os.path.join(latexdir, 'sid')
    latex_dockerfile = os.path.join(latex_os_version_dir, 'Dockerfile')

    travis_matrixlist.append(travis_matrixlist_str)

    latex_readme_tablelist.append(
        latex_readme_tablelist_holder.format(
            docker_tag, docker_url, 'sid', dockerfile_badge,
            dockerfile_url, microbadger_badge, microbadger_url))

    os.makedirs(latex_os_version_dir)

    with open(latex_dockerfile_template, 'r') as ldt:
        latex_dockerfile_template_content = ldt.read()

    latex_dockerfile_content = latex_dockerfile_template_content
    latex_dockerfile_content = re.sub('%%BASE_IMAGE%%', base_image,
                                      latex_dockerfile_content)
    latex_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                      'sid',
                                      latex_dockerfile_content)

    with open(latex_dockerfile, 'w') as ld:
        ld.write(latex_dockerfile_content)

    with open(latex_readme_template, 'r') as lrt:
        latex_readme_template_content = lrt.read()

    latex_readme_table = '\n'.join(latex_readme_tablelist)

    latex_readme_content = latex_readme_template_content
    latex_readme_content = re.sub('%%LATEX_TABLE%%', latex_readme_table,
                                  latex_readme_content)

    with open(latex_readme, 'w') as lr:
        lr.write(latex_readme_content)

    return travis_matrixlist, latex_readme_table
