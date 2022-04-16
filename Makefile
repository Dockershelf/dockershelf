#!/usr/bin/env make -f
# -*- makefile -*-

SHELL = bash -e

BASEDIR = $(shell pwd)


image:
	@docker-compose -p dockershelf -f docker-compose.yml build \
		--force-rm --pull

start:
	@docker-compose -p dockershelf -f docker-compose.yml up \
		--remove-orphans -d

console: start
	@docker-compose -p dockershelf -f docker-compose.yml exec \
		--user dockershelf dockershelf bash

update_shelf: start
	@docker-compose -p dockershelf -f docker-compose.yml exec \
		--user dockershelf dockershelf python3 update_shelf.py

stop:
	@docker-compose -p dockershelf -f docker-compose.yml stop

down:
	@docker-compose -p dockershelf -f docker-compose.yml down \
		--remove-orphans

destroy:
	@docker-compose -p dockershelf -f docker-compose.yml down \
		--rmi all --remove-orphans -v

virtualenv: start
	@docker-compose -p dockershelf -f docker-compose.yml exec \
		--user dockershelf dockershelf python -m venv --clear --copies ./winvenv
	@docker-compose -p dockershelf -f docker-compose.yml exec \
		--user dockershelf dockershelf ./winvenv/bin/pip install -U wheel setuptools
	@docker-compose -p dockershelf -f docker-compose.yml exec \
		--user dockershelf dockershelf ./winvenv/bin/pip install -r requirements.txt
	@docker-compose -p dockershelf -f docker-compose.yml exec \
		--user dockershelf dockershelf ./winvenv/bin/pip install -r requirements-dev.txt
