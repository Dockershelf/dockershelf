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


def update_latex(basedir):

    travis_matrixlist = []
    latex_readme_tablelist = []
    latexdir = os.path.join(basedir, 'latex')
    latex_dockerfile_template = os.path.join(latexdir, 'Dockerfile.template')
    latex_readme_template = os.path.join(latexdir, 'README.md.template')
    latex_readme = os.path.join(latexdir, 'README.md')
    latex_os_versions = ['stable', 'unstable']

    base_image_holder = 'dockershelf/debian:{0}'
    docker_tag_holder = 'dockershelf/latex:{0}'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-latex%2F{0}%2FDockerfile-blue.svg')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/latex/{0}/Dockerfile')
    microbadger_badge_holder = ('https://images.microbadger.com/badges/'
                                'image/dockershelf/latex:{0}.svg')
    microbadger_url_holder = ('https://microbadger.com/images/'
                              'dockershelf/latex:{0}')
    travis_matrixlist_unstable = (
        '        - DOCKER_IMAGE_NAME="dockershelf/latex:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/latex:sid"')
    travis_matrixlist_stable = (
        '        - DOCKER_IMAGE_NAME="dockershelf/latex:{0}"')
    latex_readme_tablelist_holder = ('|[`{0}`]({1})'
                                     '|`{2}`'
                                     '|[![]({3})]({4})'
                                     '|[![]({5})]({6})|')

    for deldir in find_dirs(latexdir):
        shutil.rmtree(deldir)

    for latex_os_version in latex_os_versions:
        base_image = base_image_holder.format(latex_os_version)
        latex_os_version_dir = os.path.join(latexdir, latex_os_version)
        latex_dockerfile = os.path.join(latex_os_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(latex_os_version)
        docker_url = 'https://hub.docker.com/r/dockershelf/latex'
        dockerfile_badge = dockerfile_badge_holder.format(latex_os_version)
        dockerfile_url = dockerfile_url_holder.format(latex_os_version)
        microbadger_badge = microbadger_badge_holder.format(latex_os_version)
        microbadger_url = microbadger_url_holder.format(latex_os_version)

        if latex_os_version == 'unstable':
            travis_matrixlist.append(
                travis_matrixlist_unstable.format(latex_os_version))
        else:
            travis_matrixlist.append(
                travis_matrixlist_stable.format(latex_os_version))

        latex_readme_tablelist.append(
            latex_readme_tablelist_holder.format(
                docker_tag, docker_url, latex_os_version, dockerfile_badge,
                dockerfile_url, microbadger_badge, microbadger_url))

        os.makedirs(latex_os_version_dir)

        with open(latex_dockerfile_template, 'r') as ldt:
            latex_dockerfile_template_content = ldt.read()

        latex_dockerfile_content = latex_dockerfile_template_content
        latex_dockerfile_content = re.sub('%%BASE_IMAGE%%', base_image,
                                          latex_dockerfile_content)
        latex_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                          latex_os_version,
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
