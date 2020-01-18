#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-20020, Dockershelf Developers.
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

from scripts.logger import logger
from scripts.update_debian import update_debian
from scripts.update_latex import update_latex
from scripts.update_python import update_python
from scripts.update_ruby import update_ruby
from scripts.update_node import update_node
from scripts.update_mongo import update_mongo
from scripts.update_postgres import update_postgres
from scripts.update_odoo import update_odoo
from scripts.update_php import update_php

if not sys.version_info < (3,):
    unicode = str
    basestring = str


if __name__ == '__main__':

    travis_matrixlist = []
    basedir = os.path.dirname(os.path.realpath(__file__))
    travis_template = os.path.join(basedir, '.travis.yml.template')
    travis = os.path.join(basedir, '.travis.yml')
    readme_template = os.path.join(basedir, 'README.md.template')
    readme = os.path.join(basedir, 'README.md')

    logger.start()
    logger.loglevel('INFO')
    logger.info('Updating shelves')

    debian_matrix_list, debian_readme_table = update_debian(basedir)
    latex_matrix_list, latex_readme_table = update_latex(basedir)
    python_matrix_list, python_readme_table = update_python(basedir)
    ruby_matrix_list, ruby_readme_table = update_ruby(basedir)
    node_matrix_list, node_readme_table = update_node(basedir)
    mongo_matrix_list, mongo_readme_table = update_mongo(basedir)
    postgres_matrix_list, postgres_readme_table = update_postgres(basedir)
    odoo_matrix_list, odoo_readme_table = update_odoo(basedir)
    php_matrix_list, php_readme_table = update_php(basedir)

    logger.info('Writing Travis CI matrix')
    travis_matrixlist.extend(debian_matrix_list)
    travis_matrixlist.extend(latex_matrix_list)
    travis_matrixlist.extend(python_matrix_list)
    travis_matrixlist.extend(ruby_matrix_list)
    travis_matrixlist.extend(node_matrix_list)
    travis_matrixlist.extend(mongo_matrix_list)
    travis_matrixlist.extend(postgres_matrix_list)
    travis_matrixlist.extend(odoo_matrix_list)
    travis_matrixlist.extend(php_matrix_list)

    with open(travis_template, 'r') as tt:
        travis_template_content = tt.read()

    travis_matrix = '\n'.join(travis_matrixlist)

    travis_content = travis_template_content
    travis_content = re.sub('%%MATRIX%%', travis_matrix, travis_content)

    with open(travis, 'w') as t:
        t.write(travis_content)

    logger.info('Writing top level Readme')
    with open(readme_template, 'r') as rt:
        readme_template_content = rt.read()

    readme_content = readme_template_content
    readme_content = re.sub('%%DEBIAN_TABLE%%', debian_readme_table,
                            readme_content)
    readme_content = re.sub('%%LATEX_TABLE%%', latex_readme_table,
                            readme_content)
    readme_content = re.sub('%%PYTHON_TABLE%%', python_readme_table,
                            readme_content)
    readme_content = re.sub('%%RUBY_TABLE%%', ruby_readme_table,
                            readme_content)
    readme_content = re.sub('%%NODE_TABLE%%', node_readme_table,
                            readme_content)
    readme_content = re.sub('%%MONGO_TABLE%%', mongo_readme_table,
                            readme_content)
    readme_content = re.sub('%%POSTGRES_TABLE%%', postgres_readme_table,
                            readme_content)
    readme_content = re.sub('%%ODOO_TABLE%%', odoo_readme_table,
                            readme_content)
    readme_content = re.sub('%%PHP_TABLE%%', php_readme_table,
                            readme_content)

    with open(readme, 'w') as t:
        t.write(readme_content)
