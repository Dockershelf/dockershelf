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

from scripts.logger import logger
from scripts.update_debian import update_debian
from scripts.update_latex import update_latex
from scripts.update_python import update_python
from scripts.update_node import update_node


if __name__ == '__main__':

    matrix = []
    basedir = os.path.dirname(os.path.realpath(__file__))
    workflowsdir = os.path.join(basedir, '.github', 'workflows')
    gha_develop_template = os.path.join(
        workflowsdir, 'push-develop.yml.template')
    gha_master_template = os.path.join(
        workflowsdir, 'push-master.yml.template')
    gha_schedule_template = os.path.join(
        workflowsdir, 'schedule-master.yml.template')
    gha_develop = os.path.join(workflowsdir, 'push-develop.yml')
    gha_master = os.path.join(workflowsdir, 'push-master.yml')
    gha_schedule = os.path.join(workflowsdir, 'schedule-master.yml')
    readme_template = os.path.join(basedir, 'README.md.template')
    readme = os.path.join(basedir, 'README.md')

    logger.start()
    logger.loglevel('INFO')
    logger.info('Updating shelves')

    debian_matrix_list, debian_readme_table = update_debian(basedir)
    latex_matrix_list, latex_readme_table = update_latex(basedir)
    python_matrix_list, python_readme_table = update_python(basedir)
    node_matrix_list, node_readme_table = update_node(basedir)

    logger.info('Writing github actions matrix')
    matrix.extend(debian_matrix_list)
    matrix.extend(latex_matrix_list)
    matrix.extend(python_matrix_list)
    matrix.extend(node_matrix_list)
    gha_matrix = '\n'.join(matrix)

    with open(gha_develop_template, 'r') as gdt:
        gha_develop_template_content = gdt.read()
    with open(gha_master_template, 'r') as gmt:
        gha_master_template_content = gmt.read()
    with open(gha_schedule_template, 'r') as gst:
        gha_schedule_template_content = gst.read()

    gha_develop_template_content = re.sub(
        '%%MATRIX%%', gha_matrix, gha_develop_template_content)
    gha_master_template_content = re.sub(
        '%%MATRIX%%', gha_matrix, gha_master_template_content)
    gha_schedule_template_content = re.sub(
        '%%MATRIX%%', gha_matrix, gha_schedule_template_content)

    with open(gha_develop, 'w') as t:
        t.write(gha_develop_template_content)
    with open(gha_master, 'w') as t:
        t.write(gha_master_template_content)
    with open(gha_schedule, 'w') as t:
        t.write(gha_schedule_template_content)

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
    readme_content = re.sub('%%NODE_TABLE%%', node_readme_table,
                            readme_content)

    with open(readme, 'w') as t:
        t.write(readme_content)
