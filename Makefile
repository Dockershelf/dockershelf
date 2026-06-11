#!/usr/bin/env make -f
# -*- makefile -*-

SHELL = bash -e
img_hash = $(shell docker images -q dockershelf/dockershelf:latest)
exec_on_docker = docker compose \
	-p dockershelf -f docker-compose.yml exec \
	--user dockershelf app

# Release configuration
VERSION_TYPE ?= patch
APP_NAME ?= Dockershelf

start-app:
	@if [ -z "$(img_hash)" ]; then\
		make image;\
	fi
	@make start

console: start-app
	@$(exec_on_docker) bash

discover-shelves:
	@python3 -m scripts.discover_shelf_versions

update-shelves: start-app
	@$(exec_on_docker) python3 update.py

dependencies: start-app
	@$(exec_on_docker) bundle config set --local path 'vendor/bundle'
	@$(exec_on_docker) bundle lock --add-platform x86_64-linux
	@$(exec_on_docker) bundle lock --add-platform aarch64-linux
	@$(exec_on_docker) bundle install

virtualenv:
	@python3 -m venv --clear ./virtualenv
	@./virtualenv/bin/python3 -m pip install --upgrade pip
	@./virtualenv/bin/python3 -m pip install --upgrade setuptools
	@./virtualenv/bin/python3 -m pip install --upgrade wheel
	@./virtualenv/bin/python3 -m pip install -r requirements.txt

# >>> rosey-maintainer:ops-docker BEGIN
# Managed by rosey-maintainer-tools 0.1.0. Do not edit directly.

PROJECT_NAME ?= dockershelf
all_ps_hashes = $(shell docker ps -q)

image:
	@docker compose -p $(PROJECT_NAME) -f docker-compose.yml build \
		--build-arg UID=$(shell id -u) \
		--build-arg GID=$(shell id -g)

start:
	@if [ -z "$(img_hash)" ]; then\
		make image;\
	fi
	@docker compose -p $(PROJECT_NAME) -f docker-compose.yml up \
		--remove-orphans --no-build --detach

stop:
	@docker compose -p $(PROJECT_NAME) -f docker-compose.yml stop

down:
	@docker compose -p $(PROJECT_NAME) -f docker-compose.yml down \
		--remove-orphans

destroy:
	@echo
	@echo "WARNING!!!"
	@echo "This will stop and delete all containers, images and volumes related to this project."
	@echo
	@read -p "Press ctrl+c to abort or enter to continue." -n 1 -r
	@docker compose -p $(PROJECT_NAME) -f docker-compose.yml down \
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
	@docker compose -p $(PROJECT_NAME) -f docker-compose.yml down \
		--rmi all --remove-orphans --volumes
	@docker system prune -a -f --volumes
# <<< rosey-maintainer:ops-docker END

# >>> rosey-maintainer:ops-release BEGIN
# Managed by rosey-maintainer-tools 0.1.0. Do not edit directly.

release:
	@./scripts/release.sh $${VERSION_TYPE}

release-patch:
	@./scripts/release.sh patch $${APP_NAME}

release-minor:
	@./scripts/release.sh minor $${APP_NAME}

release-major:
	@./scripts/release.sh major $${APP_NAME}

hotfix:
	@./scripts/hotfix.sh $${APP_NAME}
# <<< rosey-maintainer:ops-release END

.PHONY: start-app console discover-shelves update-shelves dependencies virtualenv \
	image start stop down destroy cataplum \
	release release-patch release-minor release-major hotfix
