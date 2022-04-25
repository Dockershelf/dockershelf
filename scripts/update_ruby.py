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

from .config import ruby_versions, ruby_versions_src_origin
from .utils import find_dirs
from .logger import logger


def update_ruby(basedir):

    matrix = []
    ruby_readme_tablelist = []
    rubydir = os.path.join(basedir, 'ruby')
    ruby_dockerfile_template = os.path.join(rubydir, 'Dockerfile.template')
    ruby_readme_template = os.path.join(rubydir, 'README.md.template')
    ruby_readme = os.path.join(rubydir, 'README.md')
    ruby_hooks_dir = os.path.join(rubydir, 'hooks')
    ruby_build_hook = os.path.join(ruby_hooks_dir, 'build')
    ruby_push_hook = os.path.join(ruby_hooks_dir, 'push')

    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/ruby:{0}'
    docker_url = 'https://hub.docker.com/r/dockershelf/ruby'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-ruby%2F{0}%2FDockerfile-blue.svg'
                               '?colorA=22313f&colorB=4a637b&cacheSeconds=900'
                               '&logo=docker')
    dockerfile_url_holder = ('https://github.com/Dockershelf/dockershelf/'
                             'blob/master/ruby/{0}/Dockerfile')
    pulls_badge_holder = ('https://img.shields.io/docker/pulls/dockershelf/ruby'
                          '?colorA=22313f&colorB=4a637b&cacheSeconds=900')
    pulls_url_holder = ('https://hub.docker.com/r/dockershelf/ruby')
    size_badge_holder = ('https://img.shields.io/docker/image-size/'
                         'dockershelf/ruby/{0}.svg'
                         '?colorA=22313f&colorB=4a637b&cacheSeconds=900')
    size_url_holder = ('https://hub.docker.com/r/dockershelf/ruby')
    matrix_latest_str = (
        '          - docker-image-name: "dockershelf/ruby:{0}"'
        '\n            docker-image-extra-tags: "dockershelf/ruby:latest"')
    matrix_str = (
        '          - docker-image-name: "dockershelf/ruby:{0}"')
    ruby_readme_tablelist_holder = ('|[`{0}`]({1})'
                                    '|`{2}`'
                                    '|[![]({3})]({4})'
                                    '|[![]({5})]({6})'
                                    '|[![]({7})]({8})'
                                    '|')
    ruby_latest_version = ruby_versions[-1]

    logger.info('Erasing current Ruby folders')
    for deldir in find_dirs(rubydir):
        shutil.rmtree(deldir)

    for ruby_version in ruby_versions:
        logger.info('Processing Ruby {0}'.format(ruby_version))
        ruby_version_dir = os.path.join(rubydir, ruby_version)
        ruby_dockerfile = os.path.join(ruby_version_dir, 'Dockerfile')

        docker_tag = docker_tag_holder.format(ruby_version)
        dockerfile_badge = dockerfile_badge_holder.format(ruby_version)
        dockerfile_url = dockerfile_url_holder.format(ruby_version)
        pulls_badge = pulls_badge_holder.format(ruby_version)
        pulls_url = pulls_url_holder.format(ruby_version)
        size_badge = size_badge_holder.format(ruby_version)
        size_url = size_url_holder.format(ruby_version)

        if ruby_version == ruby_latest_version:
            matrix.append(
                matrix_latest_str.format(ruby_version))
        else:
            matrix.append(
                matrix_str.format(ruby_version))

        ruby_readme_tablelist.append(
            ruby_readme_tablelist_holder.format(
                docker_tag, docker_url, ruby_version, dockerfile_badge,
                dockerfile_url, pulls_badge, pulls_url,
                size_badge, size_url))

        os.makedirs(ruby_version_dir)

        with open(ruby_dockerfile_template, 'r') as pdt:
            ruby_dockerfile_template_content = pdt.read()

        ruby_dockerfile_content = ruby_dockerfile_template_content
        ruby_dockerfile_content = re.sub('%%BASE_IMAGE%%',
                                         base_image,
                                         ruby_dockerfile_content)
        ruby_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%',
                                         'sid',
                                         ruby_dockerfile_content)
        ruby_dockerfile_content = re.sub('%%RUBY_VERSION%%',
                                         ruby_version,
                                         ruby_dockerfile_content)
        ruby_dockerfile_content = re.sub('%%RUBY_DEBIAN_SUITE%%',
                                         ruby_versions_src_origin[ruby_version],
                                         ruby_dockerfile_content)

        with open(ruby_dockerfile, 'w') as pd:
            pd.write(ruby_dockerfile_content)

    os.makedirs(ruby_hooks_dir)

    logger.info('Writing dummy hooks')
    with open(ruby_build_hook, 'w') as rbh:
        rbh.write('#!/usr/bin/env bash\n')
        rbh.write('echo "This is a dummy build script that just allows to '
                  'automatically fill the long description with the Readme '
                  'from GitHub."\n')
        rbh.write('echo "No real building is done here."')

    with open(ruby_push_hook, 'w') as rph:
        rph.write('#!/usr/bin/env bash\n')
        rph.write('echo "We arent really pushing."')

    logger.info('Writing Ruby Readme')
    with open(ruby_readme_template, 'r') as prt:
        ruby_readme_template_content = prt.read()

    ruby_readme_table = '\n'.join(ruby_readme_tablelist)

    ruby_readme_content = ruby_readme_template_content
    ruby_readme_content = re.sub('%%RUBY_TABLE%%',
                                 ruby_readme_table,
                                 ruby_readme_content)

    with open(ruby_readme, 'w') as pr:
        pr.write(ruby_readme_content)

    return matrix, ruby_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    update_ruby(basedir)
