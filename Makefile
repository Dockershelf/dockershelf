#!/usr/bin/env make -f
# -*- makefile -*-

SHELL = bash -e
all_ps_hashes = $(shell docker ps -q)
img_hash = $(shell docker images -q dockershelf/dockershelf:latest)
exec_on_docker = docker compose \
	-p dockershelf -f docker-compose.yml exec \
	--user dockershelf app


image:
	@docker compose -p dockershelf -f docker-compose.yml build \
		--build-arg UID=$(shell id -u) \
		--build-arg GID=$(shell id -g)

start:
	@if [ -z "$(img_hash)" ]; then\
		make image;\
	fi
	@docker compose -p dockershelf -f docker-compose.yml up \
		--remove-orphans --no-build --detach

console: start
	@$(exec_on_docker) bash

update-shelves: start
	@$(exec_on_docker) python3 update.py

dependencies: start
	@$(exec_on_docker) bundle config set --local path 'vendor/bundle'
	@$(exec_on_docker) bundle lock --add-platform x86_64-linux
	@$(exec_on_docker) bundle lock --add-platform aarch64-linux
	@$(exec_on_docker) bundle install

virtualenv: start
	@python3 -m venv --clear ./virtualenv
	@./virtualenv/bin/python3 -m pip install --upgrade pip
	@./virtualenv/bin/python3 -m pip install --upgrade setuptools
	@./virtualenv/bin/python3 -m pip install --upgrade wheel
	@./virtualenv/bin/python3 -m pip install -r requirements.txt -r requirements-dev.txt

stop:
	@docker compose -p dockershelf -f docker-compose.yml stop app

down:
	@docker compose -p dockershelf -f docker-compose.yml down \
		--remove-orphans

destroy:
	@echo
	@echo "WARNING!!!"
	@echo "This will stop and delete all containers, images and volumes related to this project."
	@echo
	@read -p "Press ctrl+c to abort or enter to continue." -n 1 -r
	@docker compose -p dockershelf -f docker-compose.yml down \
		--rmi all --remove-orphans --volumes

cataplum:
	@echo
	@echo "WARNING!!!"
	@echo "This will stop and delete all containers, images and volumes present in your system."
	@echo
	@read -p "Press ctrl+c to abort or enter to continue." -n 1 -r
	@if [ -n "$(all_ps_hashes)" ]; then\
		docker kill $(shell docker ps -q);\
	fi
	@docker compose -p dockershelf -f docker-compose.yml down \
		--rmi all --remove-orphans --volumes
	@docker system prune -a -f --volumes