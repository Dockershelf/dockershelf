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


def update_ruby(basedir):

    travis_matrixlist = []
    ruby_versions = []
    ruby_readme_tablelist = []
    rubydir = os.path.join(basedir, 'ruby')
    ruby_dockerfile_template = os.path.join(rubydir, 'Dockerfile.template')
    ruby_readme_template = os.path.join(rubydir, 'README.md.template')
    ruby_readme = os.path.join(rubydir, 'README.md')

    base_image = 'dockershelf/debian:sid'
    docker_url = 'https://hub.docker.com/r/dockershelf/ruby'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-ruby%2F{0}%2FDockerfile-blue.svg')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/ruby/{0}/Dockerfile')
    microbadger_badge_holder = ('https://images.microbadger.com/badges/'
                                'image/dockershelf/ruby:{0}.svg')
    microbadger_url_holder = ('https://microbadger.com/images/'
                              'dockershelf/ruby:{0}')
    travis_matrixlist_str = ('        '
                             '- DOCKER_IMAGE_NAME="dockershelf/ruby:{0}"')
    ruby_readme_tablelist_holder = ('|[`{0}`]({1})'
                                    '|`{2}`'
                                    '|[![]({3})]({4})'
                                    '|[![]({5})]({6})|')

    ruby_versions_src_origin = {
        '1.8': 'wheezy',
        '1.9.1': 'wheezy',
        '2.1': 'jessie',
        '2.3': 'stretch',
        '2.5': 'sid',
    }
    ruby_versions = sorted(ruby_versions_src_origin.keys())

    for deldir in find_dirs(rubydir):
        shutil.rmtree(deldir)

    for ruby_version in ruby_versions:
        ruby_os_version_dir = os.path.join(rubydir, ruby_version)
        ruby_dockerfile = os.path.join(ruby_os_version_dir, 'Dockerfile')
        dockerfile_badge = dockerfile_badge_holder.format(ruby_version)
        dockerfile_url = dockerfile_url_holder.format(ruby_version)
        microbadger_badge = microbadger_badge_holder.format(ruby_version)
        microbadger_url = microbadger_url_holder.format(ruby_version)

        travis_matrixlist.append(travis_matrixlist_str.format(ruby_version))

        ruby_readme_tablelist.append(
            ruby_readme_tablelist_holder.format(
                ruby_version, docker_url, ruby_version,
                dockerfile_badge, dockerfile_url, microbadger_badge,
                microbadger_url))

        os.makedirs(ruby_os_version_dir)

        with open(ruby_dockerfile_template, 'r') as pdt:
            ruby_dockerfile_template_content = pdt.read()

        ruby_dockerfile_content = ruby_dockerfile_template_content
        ruby_dockerfile_content = re.sub(
            '%%BASE_IMAGE%%', base_image, ruby_dockerfile_content)
        ruby_dockerfile_content = re.sub(
            '%%DEBIAN_RELEASE%%', 'sid', ruby_dockerfile_content)
        ruby_dockerfile_content = re.sub(
            '%%RUBY_VERSION%%', ruby_version, ruby_dockerfile_content)
        ruby_dockerfile_content = re.sub(
            '%%RUBY_DEBIAN_SUITE%%',
            ruby_versions_src_origin[ruby_version],
            ruby_dockerfile_content)

        with open(ruby_dockerfile, 'w') as pd:
            pd.write(ruby_dockerfile_content)

    with open(ruby_readme_template, 'r') as prt:
        ruby_readme_template_content = prt.read()

    ruby_readme_table = '\n'.join(ruby_readme_tablelist)

    ruby_readme_content = ruby_readme_template_content
    ruby_readme_content = re.sub(
        '%%RUBY_TABLE%%', ruby_readme_table, ruby_readme_content)

    with open(ruby_readme, 'w') as pr:
        pr.write(ruby_readme_content)

    return travis_matrixlist, ruby_readme_table
