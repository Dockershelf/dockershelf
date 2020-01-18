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

from .config import mongo_versions, mongo_versions_src_origin
from .utils import find_dirs
from .logger import logger


def update_mongo(basedir):

    travis_matrixlist = []
    mongo_readme_tablelist = []
    mongodir = os.path.join(basedir, 'mongo')
    mongo_dockerfile_template = os.path.join(mongodir, 'Dockerfile.template')
    mongo_readme_template = os.path.join(mongodir, 'README.md.template')
    mongo_readme = os.path.join(mongodir, 'README.md')
    mongo_hooks_dir = os.path.join(mongodir, 'hooks')
    mongo_build_hook = os.path.join(mongo_hooks_dir, 'build')
    mongo_push_hook = os.path.join(mongo_hooks_dir, 'push')

    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/mongo:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/mongo'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-mongo%2F{0}%2FDockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&maxAge=86400'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/mongo/{0}/Dockerfile')
    mb_layers_badge_holder = ('https://img.shields.io/microbadger/layers/'
                              'dockershelf/mongo/{0}.svg'
                              '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_layers_url_holder = ('https://microbadger.com/images/dockershelf/'
                            'mongo:{0}')
    mb_size_badge_holder = ('https://img.shields.io/microbadger/image-size/'
                            'dockershelf/mongo/{0}.svg'
                            '?colorA=22313f&colorB=4a637b&maxAge=86400')
    mb_size_url_holder = ('https://microbadger.com/images/dockershelf/'
                          'mongo:{0}')
    travis_matrixlist_latest_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/mongo:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/mongo:latest"')
    travis_matrixlist_str = (
        '        - DOCKER_IMAGE_NAME="dockershelf/mongo:{0}"')
    mongo_readme_tablelist_holder = ('|[`{0}`]({1})'
                                     '|`{2}`'
                                     '|[![]({3})]({4})'
                                     '|[![]({5})]({6})'
                                     '|[![]({7})]({8})'
                                     '|')
    mongo_latest_version = mongo_versions[-1]

    logger.info('Erasing current Mongo folders')
    for deldir in find_dirs(mongodir):
        shutil.rmtree(deldir)

    for mongo_version in mongo_versions:
        logger.info('Processing Mongo {0}'.format(mongo_version))
        mongo_version_dir = os.path.join(mongodir, mongo_version)
        mongo_dockerfile = os.path.join(mongo_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(mongo_version)
        dockerfile_badge = dockerfile_badge_holder.format(mongo_version)
        dockerfile_url = dockerfile_url_holder.format(mongo_version)
        mb_layers_badge = mb_layers_badge_holder.format(mongo_version)
        mb_layers_url = mb_layers_url_holder.format(mongo_version)
        mb_size_badge = mb_size_badge_holder.format(mongo_version)
        mb_size_url = mb_size_url_holder.format(mongo_version)

        if mongo_version == mongo_latest_version:
            travis_matrixlist.append(
                travis_matrixlist_latest_str.format(mongo_version))
        else:
            travis_matrixlist.append(
                travis_matrixlist_str.format(mongo_version))

        mongo_readme_tablelist.append(
            mongo_readme_tablelist_holder.format(
                docker_tag, docker_url, mongo_version, dockerfile_badge,
                dockerfile_url, mb_layers_badge, mb_layers_url,
                mb_size_badge, mb_size_url))

        os.makedirs(mongo_version_dir)

        with open(mongo_dockerfile_template, 'r') as pdt:
            mongo_dockerfile_template_content = pdt.read()

        mongo_dockerfile_content = mongo_dockerfile_template_content
        mongo_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                          base_image,
                                          mongo_dockerfile_content)
        mongo_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                          'sid',
                                          mongo_dockerfile_content)
        mongo_dockerfile_content = re.sub('%%MONGO_VERSION%%',
                                          mongo_version,
                                          mongo_dockerfile_content)
        mongo_dockerfile_content = re.sub('%%MONGO_DEBIAN_SUITE%%',
                                          mongo_versions_src_origin[mongo_version],
                                          mongo_dockerfile_content)

        with open(mongo_dockerfile, 'w') as pd:
            pd.write(mongo_dockerfile_content)

    os.makedirs(mongo_hooks_dir)

    logger.info('Writing dummy hooks')
    with open(mongo_build_hook, 'w') as mbh:
        mbh.write('#!/usr/bin/env bash\n')
        mbh.write('echo "This is a dummy build script that just allows to '
                  'automatically fill the long description with the Readme '
                  'from GitHub."\n')
        mbh.write('echo "No real building is done here."')

    with open(mongo_push_hook, 'w') as mph:
        mph.write('#!/usr/bin/env bash\n')
        mph.write('echo "We arent really pushing."')

    logger.info('Writing Mongo Readme')
    with open(mongo_readme_template, 'r') as prt:
        mongo_readme_template_content = prt.read()

    mongo_readme_table = '\n'.join(mongo_readme_tablelist)

    mongo_readme_content = mongo_readme_template_content
    mongo_readme_content = re.sub('%%MONGO_TABLE%%',
                                  mongo_readme_table,
                                  mongo_readme_content)

    with open(mongo_readme, 'w') as pr:
        pr.write(mongo_readme_content)

    return travis_matrixlist, mongo_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_mongo(basedir)
