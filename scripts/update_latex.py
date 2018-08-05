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
from .logger import logger

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
    latex_hooks_dir = os.path.join(latexdir, 'hooks')
    latex_build_hook = os.path.join(latex_hooks_dir, 'build')
    latex_push_hook = os.path.join(latex_hooks_dir, 'push')

    base_image = 'dockershelf/debian:sid'
    docker_tag = 'dockershelf/latex:sid'
    docker_url = 'https://hub.docker.com/r/dockershelf/latex'
    dockerfile_badge = ('https://img.shields.io/badge/'
                        '-latex%2Fsid%2FDockerfile-blue.svg'
                        '?colorA=22313f&colorB=4a637b&maxAge=86400'
                        '&logo=docker')
    dockerfile_url = ('https://github.com/LuisAlejandro/dockershelf/'
                      'blob/master/latex/sid/Dockerfile')
    mb_layers_badge = ('https://img.shields.io/microbadger/layers/'
                       'dockershelf/latex/sid.svg'
                       '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_layers_url = ('https://microbadger.com/images/dockershelf/'
                     'latex:sid')
    mb_size_badge = ('https://img.shields.io/microbadger/image-size/'
                     'dockershelf/latex/sid.svg'
                     '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_size_url = ('https://microbadger.com/images/dockershelf/'
                   'latex:sid')
    travis_matrixlist_str = ('        '
                             '- DOCKER_IMAGE_NAME="dockershelf/latex:sid"')
    latex_readme_tablelist_holder = ('|[`{0}`]({1})'
                                     '|`{2}`'
                                     '|[![]({3})]({4})'
                                     '|[![]({5})]({6})'
                                     '|[![]({7})]({8})'
                                     '|')

    logger.info('Erasing current Latex folders')
    for deldir in find_dirs(latexdir):
        shutil.rmtree(deldir)

    logger.info('Processing Latex')
    latex_version_dir = os.path.join(latexdir, 'sid')
    latex_dockerfile = os.path.join(latex_version_dir, 'Dockerfile')

    travis_matrixlist.append(travis_matrixlist_str)

    latex_readme_tablelist.append(
        latex_readme_tablelist_holder.format(
            docker_tag, docker_url, 'sid', dockerfile_badge,
            dockerfile_url, mb_layers_badge, mb_layers_url,
            mb_size_badge, mb_size_url))

    os.makedirs(latex_version_dir)

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

    os.makedirs(latex_hooks_dir)

    logger.info('Writing dummy hooks')
    with open(latex_build_hook, 'w') as lbh:
        lbh.write('#!/usr/bin/env bash\n')
        lbh.write('echo "This is a dummy build script that just allows to '
                  'automatically fill the long description with the Readme '
                  'from GitHub."\n')
        lbh.write('echo "No real building is done here."')

    with open(latex_push_hook, 'w') as lph:
        lph.write('#!/usr/bin/env bash\n')
        lph.write('echo "We arent really pushing."')

    logger.info('Writing Latex Readme')
    with open(latex_readme_template, 'r') as lrt:
        latex_readme_template_content = lrt.read()

    latex_readme_table = '\n'.join(latex_readme_tablelist)

    latex_readme_content = latex_readme_template_content
    latex_readme_content = re.sub('%%LATEX_TABLE%%', latex_readme_table,
                                  latex_readme_content)

    with open(latex_readme, 'w') as lr:
        lr.write(latex_readme_content)

    return travis_matrixlist, latex_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_latex(basedir)
