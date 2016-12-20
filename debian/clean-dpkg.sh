#!/usr/bin/env bash

# Exit early if there are errors.
set -e

# Delete a lot of unnecessary files.
find /usr -name "*.py[co]" -print0 | xargs -0r rm -rf
find /usr -name "__pycache__" -type d -print0 | xargs -0r rm -rf
rm -rf /usr/share/doc/* /usr/share/locale/* /usr/share/man/* \
       /var/cache/debconf/* /var/cache/apt/*