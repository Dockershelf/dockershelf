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

import sys
import time
import argparse

import psycopg2


if __name__ == '__main__':
    error = ''
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('--db_host', required=True)
    arg_parser.add_argument('--db_port', required=True)
    arg_parser.add_argument('--db_user', required=True)
    arg_parser.add_argument('--db_password', required=True)
    arg_parser.add_argument('--timeout', type=int, default=5)

    args = arg_parser.parse_args()

    start_time = time.time()
    while (time.time() - start_time) < args.timeout:
        try:
            conn = psycopg2.connect(user=args.db_user,
                                    host=args.db_host,
                                    port=args.db_port,
                                    password=args.db_password,
                                    dbname='postgres')
            time.sleep(1)
            conn.close()
            error = ''
            break
        except psycopg2.OperationalError as e:
            error = e

    if error:
        print("Database connection failure: %s" % error, file=sys.stderr)
        sys.exit(1)
