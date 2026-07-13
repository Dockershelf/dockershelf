#!/usr/bin/env make -f
# -*- makefile -*-

SHELL = bash -e
export BASH_ENV := $(HOME)/.bash_env

# Release configuration
VERSION_TYPE ?= patch
APP_NAME ?= Dockershelf
PROJECT_NAME ?= dockershelf

img_hash = $(shell docker images -q dockershelf/dockershelf:latest)
all_ps_hashes = $(shell docker ps -q)
exec_on_docker = docker compose \
	-p dockershelf -f docker-compose.yml exec \
	--user dockershelf app

# Repo-specific targets
discover-shelves:
	@python3 -m scripts.discover_shelf_versions

virtualenv:
	@python3 -m venv --clear ./virtualenv
	@./virtualenv/bin/python3 -m pip install --upgrade pip
	@./virtualenv/bin/python3 -m pip install --upgrade setuptools
	@./virtualenv/bin/python3 -m pip install --upgrade wheel
	@./virtualenv/bin/python3 -m pip install -r requirements.txt

update-shelves: start
	@$(exec_on_docker) python3 update.py

dependencies: start
	@$(exec_on_docker) bundle config set --local path 'vendor/bundle'
	@$(exec_on_docker) bundle lock --add-platform x86_64-linux
	@$(exec_on_docker) bundle lock --add-platform aarch64-linux
	@$(exec_on_docker) bundle install

build: update-shelves
	@bash scripts/build-all-images.sh develop true --no-push --yes

lint: start
	@$(exec_on_docker) tox -e lint

format: start
	@$(exec_on_docker) tox -e format

test: start
	@$(exec_on_docker) tox -e coverage

# Docker lifecycle
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

# Docker consumers
console: start
	@$(exec_on_docker) bash

# Release
release:
	@./scripts/release.sh $${VERSION_TYPE}

release-patch:
	@./scripts/release.sh patch $${APP_NAME}

release-minor:
	@./scripts/release.sh minor $${APP_NAME}

release-major:
	@./scripts/release.sh major $${APP_NAME}

release-preflight:
	@make image
	@make dependencies
	@make build
	@make format
	@make lint
	@make test

undo-release:
	@: "$${VERSION:?Set VERSION=x.y.z before running make undo-release}"
	@VERSION=$${VERSION} ./scripts/rollback.sh release

.PHONY: discover-shelves virtualenv update-shelves dependencies build lint format test \
	image start stop down destroy cataplum console release release-patch release-minor \
	release-major release-preflight undo-release
