![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/travis/Dockershelf/dockershelf.svg)](https://travis-ci.org/Dockershelf/dockershelf) [![](https://img.shields.io/github/issues-raw/Dockershelf/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/Dockershelf/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/Dockershelf/dockershelf.svg)](https://gitter.im/Dockershelf/dockershelf) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

Current version: 2.6.1

*Dockershelf* is a repository that serves as a collector for docker recipes that are universal, efficient and slim. We keep adding "shelves", which are holders for the different versions of a popular language or application.

All shelves are currently based off Debian Sid, the development version of Debian. Images are updated, tested and published *daily* via a Travis cron job.

## Shelves

### Debian

These images are similar to the official ones, but with some improved configurations. Check out [debian/README.md](https://github.com/Dockershelf/dockershelf/blob/master/debian/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/debian:buster`](https://hub.docker.com/r/dockershelf/debian)|`buster`|[![](https://img.shields.io/badge/-debian%2Fbuster%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/buster/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/buster.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:bullseye`](https://hub.docker.com/r/dockershelf/debian)|`bullseye`|[![](https://img.shields.io/badge/-debian%2Fbullseye%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/bullseye/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/bullseye.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:bookworm`](https://hub.docker.com/r/dockershelf/debian)|`bookworm`|[![](https://img.shields.io/badge/-debian%2Fbookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:sid`](https://hub.docker.com/r/dockershelf/debian)|`sid`|[![](https://img.shields.io/badge/-debian%2Fsid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

### Python

These are python images with native debian packages that are extracted from different debian releases. Check out [python/README.md](https://github.com/Dockershelf/dockershelf/blob/master/python/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/python:2.7`](https://hub.docker.com/r/dockershelf/python)|`2.7`|[![](https://img.shields.io/badge/-python%2F2.7%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/2.7/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/2.7.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.5`](https://hub.docker.com/r/dockershelf/python)|`3.5`|[![](https://img.shields.io/badge/-python%2F3.5%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.5/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.5.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.6`](https://hub.docker.com/r/dockershelf/python)|`3.6`|[![](https://img.shields.io/badge/-python%2F3.6%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.6/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.6.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.8`](https://hub.docker.com/r/dockershelf/python)|`3.8`|[![](https://img.shields.io/badge/-python%2F3.8%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.8/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.8.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.9`](https://hub.docker.com/r/dockershelf/python)|`3.9`|[![](https://img.shields.io/badge/-python%2F3.9%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.9/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.9.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.10`](https://hub.docker.com/r/dockershelf/python)|`3.10`|[![](https://img.shields.io/badge/-python%2F3.10%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.10/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.10.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

### Ruby

These are ruby images with native debian packages that are extracted from different debian releases. Check out [ruby/README.md](https://github.com/Dockershelf/dockershelf/blob/master/ruby/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/ruby:2.1`](https://hub.docker.com/r/dockershelf/ruby)|`2.1`|[![](https://img.shields.io/badge/-ruby%2F2.1%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/ruby/2.1/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/ruby?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/ruby)|[![](https://img.shields.io/docker/image-size/dockershelf/ruby/2.1.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/ruby)|
|[`dockershelf/ruby:2.3`](https://hub.docker.com/r/dockershelf/ruby)|`2.3`|[![](https://img.shields.io/badge/-ruby%2F2.3%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/ruby/2.3/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/ruby?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/ruby)|[![](https://img.shields.io/docker/image-size/dockershelf/ruby/2.3.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/ruby)|
|[`dockershelf/ruby:2.7`](https://hub.docker.com/r/dockershelf/ruby)|`2.7`|[![](https://img.shields.io/badge/-ruby%2F2.7%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/ruby/2.7/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/ruby?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/ruby)|[![](https://img.shields.io/docker/image-size/dockershelf/ruby/2.7.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/ruby)|
|[`dockershelf/ruby:3.0`](https://hub.docker.com/r/dockershelf/ruby)|`3.0`|[![](https://img.shields.io/badge/-ruby%2F3.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/ruby/3.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/ruby?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/ruby)|[![](https://img.shields.io/docker/image-size/dockershelf/ruby/3.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/ruby)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

### Node

These are Node images built using the [nodesource installation script](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions). Check out [node/README.md](https://github.com/Dockershelf/dockershelf/blob/master/node/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/node:10`](https://hub.docker.com/r/dockershelf/node)|`10`|[![](https://img.shields.io/badge/-node%2F10%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/10/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/10.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:12`](https://hub.docker.com/r/dockershelf/node)|`12`|[![](https://img.shields.io/badge/-node%2F12%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/12/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/12.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:14`](https://hub.docker.com/r/dockershelf/node)|`14`|[![](https://img.shields.io/badge/-node%2F14%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/14/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/14.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:15`](https://hub.docker.com/r/dockershelf/node)|`15`|[![](https://img.shields.io/badge/-node%2F15%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/15/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/15.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:16`](https://hub.docker.com/r/dockershelf/node)|`16`|[![](https://img.shields.io/badge/-node%2F16%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/16/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/16.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:17`](https://hub.docker.com/r/dockershelf/node)|`17`|[![](https://img.shields.io/badge/-node%2F17%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/17/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/17.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

### Mongo

These are Mongo images built using the [official installation guide](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/). Check out [mongo/README.md](https://github.com/Dockershelf/dockershelf/blob/master/mongo/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/mongo:4.2`](https://hub.docker.com/r/dockershelf/mongo)|`4.2`|[![](https://img.shields.io/badge/-mongo%2F4.2%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/4.2/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/mongo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|[![](https://img.shields.io/docker/image-size/dockershelf/mongo/4.2.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|
|[`dockershelf/mongo:4.4`](https://hub.docker.com/r/dockershelf/mongo)|`4.4`|[![](https://img.shields.io/badge/-mongo%2F4.4%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/4.4/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/mongo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|[![](https://img.shields.io/docker/image-size/dockershelf/mongo/4.4.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|
|[`dockershelf/mongo:5.0`](https://hub.docker.com/r/dockershelf/mongo)|`5.0`|[![](https://img.shields.io/badge/-mongo%2F5.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/5.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/mongo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|[![](https://img.shields.io/docker/image-size/dockershelf/mongo/5.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

### Postgres

These are PostgreSQL images built using the [official installation guide](https://www.postgresql.org/download/linux/debian/). Check out [postgres/README.md](https://github.com/Dockershelf/dockershelf/blob/master/postgres/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/postgres:9.6`](https://hub.docker.com/r/dockershelf/postgres)|`9.6`|[![](https://img.shields.io/badge/-postgres%2F9.6%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/9.6/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/9.6.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|
|[`dockershelf/postgres:10`](https://hub.docker.com/r/dockershelf/postgres)|`10`|[![](https://img.shields.io/badge/-postgres%2F10%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/10/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/10.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|
|[`dockershelf/postgres:11`](https://hub.docker.com/r/dockershelf/postgres)|`11`|[![](https://img.shields.io/badge/-postgres%2F11%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/11/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/11.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|
|[`dockershelf/postgres:12`](https://hub.docker.com/r/dockershelf/postgres)|`12`|[![](https://img.shields.io/badge/-postgres%2F12%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/12/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/12.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|
|[`dockershelf/postgres:13`](https://hub.docker.com/r/dockershelf/postgres)|`13`|[![](https://img.shields.io/badge/-postgres%2F13%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/13/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/13.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|
|[`dockershelf/postgres:14`](https://hub.docker.com/r/dockershelf/postgres)|`14`|[![](https://img.shields.io/badge/-postgres%2F14%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/14/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/14.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

### Latex

This is a Latex image built with the following packages installed: `texlive-fonts-recommended`, `texlive-latex-base`, `texlive-latex-extra` and `latex-xcolor`. It should be enough to use the `pdflatex` binary for basic Latex to PDF conversion. Check out [latex/README.md](https://github.com/Dockershelf/dockershelf/blob/master/latex/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/latex:basic`](https://hub.docker.com/r/dockershelf/latex)|`basic`|[![](https://img.shields.io/badge/-latex%2Fbasic%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/basic/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/basic.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|
|[`dockershelf/latex:full`](https://hub.docker.com/r/dockershelf/latex)|`full`|[![](https://img.shields.io/badge/-latex%2Ffull%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/full/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/full.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

### Odoo

These images are similar to the official ones, but with some improved configurations. Check out [odoo/README.md](https://github.com/Dockershelf/dockershelf/blob/master/odoo/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/odoo:11.0`](https://hub.docker.com/r/dockershelf/odoo)|`11.0`|[![](https://img.shields.io/badge/-odoo%2F11.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/11.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/11.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:12.0`](https://hub.docker.com/r/dockershelf/odoo)|`12.0`|[![](https://img.shields.io/badge/-odoo%2F12.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/12.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/12.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:13.0`](https://hub.docker.com/r/dockershelf/odoo)|`13.0`|[![](https://img.shields.io/badge/-odoo%2F13.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/13.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/13.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:14.0`](https://hub.docker.com/r/dockershelf/odoo)|`14.0`|[![](https://img.shields.io/badge/-odoo%2F14.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/14.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/14.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

### PHP


|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/php:7.0`](https://hub.docker.com/r/dockershelf/php)|`7.0`|[![](https://img.shields.io/badge/-php%2F7.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:7.2`](https://hub.docker.com/r/dockershelf/php)|`7.2`|[![](https://img.shields.io/badge/-php%2F7.2%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.2/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.2.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:7.3`](https://hub.docker.com/r/dockershelf/php)|`7.3`|[![](https://img.shields.io/badge/-php%2F7.3%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.3/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.3.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:7.4`](https://hub.docker.com/r/dockershelf/php)|`7.4`|[![](https://img.shields.io/badge/-php%2F7.4%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.4/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.4.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:8.0`](https://hub.docker.com/r/dockershelf/php)|`8.0`|[![](https://img.shields.io/badge/-php%2F8.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/8.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/8.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

## How to download

Pull one of the available images and start hacking!

```bash
docker pull [docker image name]
docker run -it [docker image name] bash
```
<sup>[docker image name] is the desired image to download, for example <code>dockershelf/python:2.7</code>.</sup>

## How to build locally

Clone this repository to your machine.

```bash
git clone https://github.com/Dockershelf/dockershelf
```

Run the build script in the root folder of your local copy. Remember to have docker installed and make sure your user has proper privileges to execute `docker build`.

```bash
bash build-image.sh [docker image name]
```

<sup>[docker image name] is the desired image to build, for example <code>dockershelf/debian:sid</code>.</sup>

## Made with :heart: and :hamburger:

![Banner](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/promo-open-source.svg)

> Web [collagelabs.org](http://collagelabs.org/) · GitHub [@CollageLabs](https://github.com/CollageLabs) · Twitter [@CollageLabs](https://twitter.com/CollageLabs)