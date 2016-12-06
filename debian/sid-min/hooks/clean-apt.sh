#!/usr/bin/env bash

# Exit early if there are errors.
set -e

# Delete all debian packages from cache and apt cache itself.
rm -rf /var/cache/apt/*