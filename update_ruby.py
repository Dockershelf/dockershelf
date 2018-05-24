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
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen

from pkg_resources import parse_version

from utils import find_dirs

if not sys.version_info < (3,):
    unicode = str
    basestring = str

versions = {'cpython': {}}
python_versions_list_file = ('https://raw.githubusercontent.com/saghul/'
                             'pythonz/master/pythonz/installer/'
                             'versions.py')
with closing(urlopen(python_versions_list_file)) as p:
    exec(p.read())


def update_python(basedir):

    travis_matrixlist = []
    python_versions = []
    python_readme_tablelist = []
    pythondir = os.path.join(basedir, 'python')
    python_dockerfile_template = os.path.join(pythondir, 'Dockerfile.template')
    python_readme_template = os.path.join(pythondir, 'README.md.template')
    python_readme = os.path.join(pythondir, 'README.md')

    base_image_holder = 'dockershelf/debian:{0}'
    python_os_version_holder = '{0}-{1}'
    docker_tag_holder = 'dockershelf/python:{0}'
    dockerfile_badge_holder = ('https://img.shields.io/badge/'
                               '-python%2F{0}%2FDockerfile-blue.svg')
    dockerfile_url_holder = ('https://github.com/LuisAlejandro/dockershelf/'
                             'blob/master/python/{0}/Dockerfile')
    microbadger_badge_holder = ('https://images.microbadger.com/badges/'
                                'image/dockershelf/python:{0}.svg')
    microbadger_url_holder = ('https://microbadger.com/images/'
                              'dockershelf/python:{0}')
    travis_matrixlist_unstable_py2 = (
        '        - DOCKER_IMAGE_NAME="dockershelf/python:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/python:{1}'
        ' dockershelf/python:2"')
    travis_matrixlist_unstable_py3 = (
        '        - DOCKER_IMAGE_NAME="dockershelf/python:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/python:{1}'
        ' dockershelf/python:3"')
    travis_matrixlist_unstable = (
        '        - DOCKER_IMAGE_NAME="dockershelf/python:{0}"'
        ' DOCKER_IMAGE_EXTRA_TAGS="dockershelf/python:{1}"')
    travis_matrixlist_stable = (
        '        - DOCKER_IMAGE_NAME="dockershelf/python:{0}"')
    python_readme_tablelist_holder = ('|[`{0}`]({1})'
                                      '|`{2}`'
                                      '|[![]({3})]({4})'
                                      '|[![]({5})]({6})|')

    python_versions_pre = versions['cpython'].keys()
    python_versions_sel = set(map(lambda x: '.'.join(x.split('.')[:2]),
                                  python_versions_pre))
    python_versions_sel = python_versions_sel - set(['2.4', '2.5', '3.0',
                                                     '3.1', '3.3'])

    for vsel in python_versions_sel:
        psel = set(filter(lambda x: '.'.join(x.split('.')[:2]) == vsel,
                          python_versions_pre))
        psel = [parse_version(x) for x in psel]
        psel.sort()
        python_versions.append(str(psel[-1]))

    for deldir in find_dirs(pythondir):
        shutil.rmtree(deldir)

    for python_version in python_versions:
        python_version_short = '.'.join(python_version.split('.')[:2])

        for python_os in ['stable', 'unstable']:
            base_image = base_image_holder.format(python_os)
            python_os_version = python_os_version_holder.format(
                python_version_short, python_os)
            python_os_version_dir = os.path.join(pythondir, python_os_version)
            python_dockerfile = os.path.join(python_os_version_dir,
                                             'Dockerfile')

            docker_tag = docker_tag_holder.format(python_os_version)
            docker_url = 'https://hub.docker.com/r/dockershelf/python'
            dockerfile_badge = dockerfile_badge_holder.format(
                python_os_version)
            dockerfile_url = dockerfile_url_holder.format(python_os_version)
            microbadger_badge = microbadger_badge_holder.format(
                python_os_version)
            microbadger_url = microbadger_url_holder.format(python_os_version)

            if python_os == 'unstable':
                if python_version_short == '2.7':
                    travis_matrixlist.append(
                        travis_matrixlist_unstable_py2.format(
                            python_os_version, python_version_short))
                elif python_version_short == '3.5':
                    travis_matrixlist.append(
                        travis_matrixlist_unstable_py3.format(
                            python_os_version, python_version_short))
                else:
                    travis_matrixlist.append(
                        travis_matrixlist_unstable.format(
                            python_os_version, python_version_short))
            else:
                travis_matrixlist.append(
                    travis_matrixlist_stable.format(python_os_version))

            python_readme_tablelist.append(
                python_readme_tablelist_holder.format(
                    docker_tag, docker_url, python_os_version,
                    dockerfile_badge, dockerfile_url, microbadger_badge,
                    microbadger_url))

            os.makedirs(python_os_version_dir)

            with open(python_dockerfile_template, 'r') as pdt:
                python_dockerfile_template_content = pdt.read()

            python_dockerfile_content = python_dockerfile_template_content
            python_dockerfile_content = re.sub('%%BASE_IMAGE%%', base_image,
                                               python_dockerfile_content)
            python_dockerfile_content = re.sub('%%DEBIAN_RELEASE%%', python_os,
                                               python_dockerfile_content)
            python_dockerfile_content = re.sub('%%PYTHON_VERSION%%',
                                               python_version,
                                               python_dockerfile_content)
            python_dockerfile_content = re.sub('%%PYTHON_VERSION_SHORT%%',
                                               python_version_short,
                                               python_dockerfile_content)

            with open(python_dockerfile, 'w') as pd:
                pd.write(python_dockerfile_content)

    with open(python_readme_template, 'r') as prt:
        python_readme_template_content = prt.read()

    python_readme_table = '\n'.join(python_readme_tablelist)

    python_readme_content = python_readme_template_content
    python_readme_content = re.sub('%%PYTHON_TABLE%%', python_readme_table,
                                   python_readme_content)

    with open(python_readme, 'w') as pr:
        pr.write(python_readme_content)

    return travis_matrixlist, python_readme_table
