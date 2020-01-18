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

from .utils import get_debian_versions, get_mongo_versions, \
    get_mongo_versions_src_origin, get_node_versions, get_odoo_versions, \
    get_postgres_versions, get_python_versions_src_origin, get_python_versions, \
    get_ruby_versions_src_origin, get_ruby_versions, get_php_versions_src_origin, \
    get_php_versions

latex_versions = ['basic', 'full']
debian_versions = get_debian_versions()
mongo_versions_src_origin = get_mongo_versions_src_origin(debian_versions)
mongo_versions = get_mongo_versions(mongo_versions_src_origin)
node_versions = get_node_versions()
odoo_versions = get_odoo_versions()
postgres_versions = get_postgres_versions()
python_versions_src_origin = get_python_versions_src_origin()
python_versions = get_python_versions(python_versions_src_origin)
ruby_versions_src_origin = get_ruby_versions_src_origin()
ruby_versions = get_ruby_versions(ruby_versions_src_origin)
php_versions_src_origin = get_php_versions_src_origin()
php_versions = get_php_versions(php_versions_src_origin)
