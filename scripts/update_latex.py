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

from .config import latex_versions
from .utils import find_dirs
from .logger import logger


def update_latex(basedir):

    matrix = []
    latex_readme_tablelist = []
    latexdir = os.path.join(basedir, 'latex')
    latex_dockerfile_template = os.path.join(latexdir, 'Dockerfile.template')
    latex_readme_template = os.path.join(latexdir, 'README.md.template')
    latex_readme = os.path.join(latexdir, 'README.md')

    base_image = 'dockershelf/debian:bookworm'
    docker_tag_holder = 'dockershelf/latex:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/latex'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-Dockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/latex/{0}/Dockerfile')
    pulls_badge_holder = ('https://img.shields.io/docker/pulls/dockershelf/'
                          'latex?colorA=22313f&colorB=4a637b'
                          '')
    pulls_url_holder = ('https://hub.docker.com/r/dockershelf/latex')
    size_badge_holder = ('https://img.shields.io/docker/image-size/'
                         'dockershelf/latex/{0}.svg'
                         '?colorA=22313f&colorB=4a637b')
    size_url_holder = ('https://hub.docker.com/r/dockershelf/latex')
    matrix_str = (
        '          - docker-image-name: "dockershelf/latex:{0}"')
    latex_readme_tablelist_holder = ('|[`{0}`]({1})'
                                     '|[![]({2})]({3})'
                                     '|[![]({4})]({5})'
                                     '|[![]({6})]({7})'
                                     '|')

    logger.info('Erasing current Latex folders')
    for deldir in find_dirs(latexdir):
        shutil.rmtree(deldir)

    for latex_version_long in latex_versions:
        logger.info('Processing Latex {0}'.format(latex_version_long))
        latex_version_dir = os.path.join(latexdir, latex_version_long)
        latex_dockerfile = os.path.join(latex_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(latex_version_long)
        dockerfile_badge = dockerfile_badge_holder.format(latex_version_long)
        dockerfile_url = dockerfile_url_holder.format(latex_version_long)
        pulls_badge = pulls_badge_holder.format(latex_version_long)
        pulls_url = pulls_url_holder.format(latex_version_long)
        size_badge = size_badge_holder.format(latex_version_long)
        size_url = size_url_holder.format(latex_version_long)

        matrix.append(
            matrix_str.format(latex_version_long))

        latex_readme_tablelist.append(
            latex_readme_tablelist_holder.format(
                docker_tag, docker_url, dockerfile_badge,
                dockerfile_url, pulls_badge, pulls_url,
                size_badge, size_url))

        os.makedirs(latex_version_dir)

        with open(latex_dockerfile_template, 'r') as ldt:
            latex_dockerfile_template_content = ldt.read()

        latex_dockerfile_content = latex_dockerfile_template_content
        latex_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                          base_image,
                                          latex_dockerfile_content)
        latex_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                          'sid',
                                          latex_dockerfile_content)
        latex_dockerfile_content = re.sub('%%LATEX_VERSION%%',
                                          latex_version_long,
                                          latex_dockerfile_content)

        with open(latex_dockerfile, 'w') as ld:
            ld.write(latex_dockerfile_content)

    logger.info('Writing Latex Readme')
    with open(latex_readme_template, 'r') as lrt:
        latex_readme_template_content = lrt.read()

    latex_readme_table = '\n'.join(latex_readme_tablelist)

    latex_readme_content = latex_readme_template_content
    latex_readme_content = re.sub('%%LATEX_TABLE%%',
                                  latex_readme_table,
                                  latex_readme_content)

    with open(latex_readme, 'w') as lr:
        lr.write(latex_readme_content)

    return matrix, latex_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_latex(basedir)
