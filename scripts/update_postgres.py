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
from contextlib import closing

try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

from .utils import find_dirs, is_string_a_string, u

if not sys.version_info < (3,):
    unicode = str
    basestring = str


def update_postgres(basedir):

    travis_matrixlist = []
    postgres_readme_tablelist = []
    postgresdir = os.path.join(basedir, 'postgres')
    postgres_dockerfile_template = os.path.join(postgresdir,
                                                'Dockerfile.template')
    postgres_readme_template = os.path.join(postgresdir, 'README.md.template')
    postgres_readme = os.path.join(postgresdir, 'README.md')

    postgres_release_url = ('http://apt.postgresql.org/pub/repos/apt/'
                            'dists/sid-pgdg/Release')
    base_image = 'dockershelf/debian:sid'
    docker_tag_holder = 'dockershelf/postgres:{0}'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-postgres%2F{0}%2FDockerfile-blue.svg')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/postgres/{0}/Dockerfile')
    microbadger_badge_holder = ('https://images.microbadger.com/badges/'
                                'image/dockershelf/postgres:{0}.svg')
    microbadger_url_holder = ('https://microbadger.com/images/'
                              'dockershelf/postgres:{0}')
    travis_matrixlist_str = ('        '
                             '- DOCKER_IMAGE_NAME="dockershelf/postgres:{0}"')
    latex_readme_tablelist_holder = ('|[`{0}`]({1})'
                                     '|`{2}`'
                                     '|[![]({3})]({4})'
                                     '|[![]({5})]({6})|')

    postgres_version_cut = 9.3

    r = Request(postgres_release_url)

    with closing(urlopen(r)) as d:
        postgres_release_content = d.read()

    postgres_versions = re.findall('Components: (.*)',
                                   u(postgres_release_content))[0]
    postgres_versions = list(filter(lambda x: not is_string_a_string(x),
                                    postgres_versions.split()))
    postgres_versions = [v for v in postgres_versions
                         if float(v) >= postgres_version_cut]

    for deldir in find_dirs(postgresdir):
        shutil.rmtree(deldir)

    for postgres_version in postgres_versions:
        postgres_os_version_dir = os.path.join(postgresdir, postgres_version)
        postgres_dockerfile = os.path.join(postgres_os_version_dir,
                                           'Dockerfile')

        docker_tag = docker_tag_holder.format(postgres_version)
        docker_url = 'https://hub.docker.com/r/dockershelf/postgres'
        dockerfile_badge = dockerfile_badge_holder.format(postgres_version)
        dockerfile_url = dockerfile_url_holder.format(postgres_version)
        microbadger_badge = microbadger_badge_holder.format(postgres_version)
        microbadger_url = microbadger_url_holder.format(postgres_version)

        travis_matrixlist.append(
            travis_matrixlist_str.format(postgres_version))

        postgres_readme_tablelist.append(
            latex_readme_tablelist_holder.format(
                docker_tag, docker_url, postgres_version, dockerfile_badge,
                dockerfile_url, microbadger_badge, microbadger_url))

        os.makedirs(postgres_os_version_dir)

        with open(postgres_dockerfile_template, 'r') as pdt:
            postgres_dockerfile_template_content = pdt.read()

        postgres_dockerfile_content = postgres_dockerfile_template_content
        postgres_dockerfile_content = re.sub(
            '%%BASE_IMAGE%%', base_image, postgres_dockerfile_content)
        postgres_dockerfile_content = re.sub(
            '%%DEBIAN_RELEASE%%', 'sid', postgres_dockerfile_content)
        postgres_dockerfile_content = re.sub(
            '%%POSTGRES_VERSION%%', postgres_version,
            postgres_dockerfile_content)

        with open(postgres_dockerfile, 'w') as pd:
            pd.write(postgres_dockerfile_content)

    with open(postgres_readme_template, 'r') as prt:
        postgres_readme_template_content = prt.read()

    postgres_readme_table = '\n'.join(postgres_readme_tablelist)

    postgres_readme_content = postgres_readme_template_content
    postgres_readme_content = re.sub('%%POSTGRES_TABLE%%',
                                     postgres_readme_table,
                                     postgres_readme_content)

    with open(postgres_readme, 'w') as pr:
        pr.write(postgres_readme_content)

    return travis_matrixlist, postgres_readme_table


if __name__ == '__main__':
    basedir = os.path.dirname(os.path.realpath(__file__))
    update_postgres(basedir)
