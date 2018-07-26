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

from .utils import find_dirs

if not sys.version_info < (3,):
    unicode = str
    basestring = str


def update_mongo(basedir):

    travis_matrixlist = []
    mongo_readme_tablelist = []
    mongodir = os.path.join(basedir, 'mongo')
    mongo_dockerfile_template = os.path.join(mongodir, 'Dockerfile.template')
    mongo_readme_template = os.path.join(mongodir, 'README.md.template')
    mongo_readme = os.path.join(mongodir, 'README.md')

    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/mongo:{0}'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-mongo%2F{0}%2FDockerfile-blue.svg')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/mongo/{0}/Dockerfile')
    microbadger_badge_holder = ('https://images.microbadger.com/badges/'
                                'image/dockershelf/mongo:{0}.svg')
    microbadger_url_holder = ('https://microbadger.com/images/'
                              'dockershelf/mongo:{0}')
    travis_matrixlist_str = ('        '
                             '- DOCKER_IMAGE_NAME="dockershelf/mongo:{0}"')
    latex_readme_tablelist_holder = ('|[`{0}`]({1})'
                                     '|`{2}`'
                                     '|[![]({3})]({4})'
                                     '|[![]({5})]({6})|')

    mongo_versions_src_origin = {
        '3.2': 'jessie',
        '3.4': 'jessie',
        '3.6': 'stretch',
        '4.0': 'stretch',
    }
    mongo_versions = sorted(mongo_versions_src_origin.keys())

    for deldir in find_dirs(mongodir):
        shutil.rmtree(deldir)

    for mongo_version in mongo_versions:
        mongo_os_version_dir = os.path.join(mongodir, mongo_version)
        mongo_dockerfile = os.path.join(mongo_os_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(mongo_version)
        docker_url = 'https://hub.docker.com/r/dockershelf/mongo'
        dockerfile_badge = dockerfile_badge_holder.format(mongo_version)
        dockerfile_url = dockerfile_url_holder.format(mongo_version)
        microbadger_badge = microbadger_badge_holder.format(mongo_version)
        microbadger_url = microbadger_url_holder.format(mongo_version)

        travis_matrixlist.append(travis_matrixlist_str.format(mongo_version))

        mongo_readme_tablelist.append(
            latex_readme_tablelist_holder.format(
                docker_tag, docker_url, mongo_version, dockerfile_badge,
                dockerfile_url, microbadger_badge, microbadger_url))

        os.makedirs(mongo_os_version_dir)

        with open(mongo_dockerfile_template, 'r') as pdt:
            mongo_dockerfile_template_content = pdt.read()

        mongo_dockerfile_content = mongo_dockerfile_template_content
        mongo_dockerfile_content = re.sub(
            '%%BASE_IMAGE%%', base_image, mongo_dockerfile_content)
        mongo_dockerfile_content = re.sub(
            '%%DEBIAN_RELEASE%%', 'sid', mongo_dockerfile_content)
        mongo_dockerfile_content = re.sub(
            '%%MONGO_VERSION%%', mongo_version, mongo_dockerfile_content)
        mongo_dockerfile_content = re.sub(
            '%%MONGO_DEBIAN_SUITE%%', mongo_versions_src_origin[mongo_version],
            mongo_dockerfile_content)

        with open(mongo_dockerfile, 'w') as pd:
            pd.write(mongo_dockerfile_content)

    with open(mongo_readme_template, 'r') as prt:
        mongo_readme_template_content = prt.read()

    mongo_readme_table = '\n'.join(mongo_readme_tablelist)

    mongo_readme_content = mongo_readme_template_content
    mongo_readme_content = re.sub('%%MONGO_TABLE%%', mongo_readme_table,
                                  mongo_readme_content)

    with open(mongo_readme, 'w') as pr:
        pr.write(mongo_readme_content)

    return travis_matrixlist, mongo_readme_table
