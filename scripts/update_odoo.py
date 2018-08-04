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


def update_odoo(basedir):

    travis_matrixlist = []
    odoo_versions = []
    odoo_readme_tablelist = []
    odoodir = os.path.join(basedir, 'odoo')
    odoo_dockerfile_template = os.path.join(odoodir, 'Dockerfile.template')
    odoo_readme_template = os.path.join(odoodir, 'README.md.template')
    odoo_readme = os.path.join(odoodir, 'README.md')
    odoo_hooks_dir = os.path.join(odoodir, 'hooks')
    odoo_build_hook = os.path.join(odoo_hooks_dir, 'build')
    odoo_push_hook = os.path.join(odoo_hooks_dir, 'push')

    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/odoo:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/odoo'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-odoo%2F{0}%2FDockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&maxAge=86400'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/odoo/{0}/Dockerfile')
    mb_layers_badge_holder = ('https://img.shields.io/microbadger/layers/'
                              'dockershelf/odoo/{0}.svg'
                              '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_layers_url_holder = ('https://microbadger.com/images/dockershelf/'
                            'odoo:{0}')
    mb_size_badge_holder = ('https://img.shields.io/microbadger/image-size/'
                            'dockershelf/odoo/{0}.svg'
                            '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_size_url_holder = ('https://microbadger.com/images/dockershelf/'
                          'odoo:{0}')
    travis_matrixlist_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/odoo:{0}"')
    odoo_readme_tablelist_holder = ('|[`{0}`]({1})'
                                    '|`{2}`'
                                    '|[![]({3})]({4})'
                                    '|[![]({5})]({6})'
                                    '|[![]({7})]({8})'
                                    '|')

    odoo_versions_src_origin = {
        '2.6': 'wheezy-security',
        '2.7': 'sid',
        '3.2': 'wheezy-security',
        '3.4': 'jessie',
        '3.5': 'sid',
        '3.6': 'sid',
        '3.7': 'sid',
    }

    odoo_versions = sorted(odoo_versions_src_origin.keys())

    for deldir in find_dirs(odoodir):
        shutil.rmtree(deldir)

    for odoo_version in odoo_versions:
        odoo_version_dir = os.path.join(odoodir, odoo_version)
        odoo_dockerfile = os.path.join(odoo_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(odoo_version)
        dockerfile_badge = dockerfile_badge_holder.format(odoo_version)
        dockerfile_url = dockerfile_url_holder.format(odoo_version)
        mb_layers_badge = mb_layers_badge_holder.format(odoo_version)
        mb_layers_url = mb_layers_url_holder.format(odoo_version)
        mb_size_badge = mb_size_badge_holder.format(odoo_version)
        mb_size_url = mb_size_url_holder.format(odoo_version)

        travis_matrixlist.append(travis_matrixlist_str.format(odoo_version))

        odoo_readme_tablelist.append(
            odoo_readme_tablelist_holder.format(
                docker_tag, docker_url, odoo_version, dockerfile_badge,
                dockerfile_url, mb_layers_badge, mb_layers_url,
                mb_size_badge, mb_size_url))

        os.makedirs(odoo_version_dir)

        with open(odoo_dockerfile_template, 'r') as pdt:
            odoo_dockerfile_template_content = pdt.read()

        odoo_dockerfile_content = odoo_dockerfile_template_content
        odoo_dockerfile_content = re.sub(
            '%%BASE_IMAGE%%', base_image, odoo_dockerfile_content)
        odoo_dockerfile_content = re.sub(
            '%%DEBIAN_RELEASE%%', 'sid', odoo_dockerfile_content)
        odoo_dockerfile_content = re.sub(
            '%%ODOO_VERSION%%', odoo_version, odoo_dockerfile_content)
        odoo_dockerfile_content = re.sub(
            '%%ODOO_DEBIAN_SUITE%%',
            odoo_versions_src_origin[odoo_version],
            odoo_dockerfile_content)

        with open(odoo_dockerfile, 'w') as pd:
            pd.write(odoo_dockerfile_content)

    os.makedirs(odoo_hooks_dir)

    with open(odoo_build_hook, 'w') as pbh:
        pbh.write('#!/usr/bin/env bash\n')
        pbh.write('echo "This is a dummy build script that just allows to '
                  'automatically fill the long description with the Readme '
                  'from GitHub."\n')
        pbh.write('echo "No real building is done here."')

    with open(odoo_push_hook, 'w') as pph:
        pph.write('#!/usr/bin/env bash\n')
        pph.write('echo "We arent really pushing."')

    with open(odoo_readme_template, 'r') as prt:
        odoo_readme_template_content = prt.read()

    odoo_readme_table = '\n'.join(odoo_readme_tablelist)

    odoo_readme_content = odoo_readme_template_content
    odoo_readme_content = re.sub('%%ODOO_TABLE%%', odoo_readme_table,
                                 odoo_readme_content)

    with open(odoo_readme, 'w') as pr:
        pr.write(odoo_readme_content)

    return travis_matrixlist, odoo_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.realpath(__file__))
    update_odoo(basedir)
