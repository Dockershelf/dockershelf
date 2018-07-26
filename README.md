![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

Current version: 0.1.5

*Dockershelf* is a repository that serves as a collector for docker recipes that are universal, efficient and slim. We keep adding "shelves", which are holders for the different versions of a popular language or application.

All shelves are currently based off Debian Sid, the development version of Debian. Images are updated, tested and published *daily* via a Travis cron job.

## Shelves

### Debian

These images are similar to the official ones, but with some improved configurations. Check out [debian/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/debian/README.md) for more details.

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`dockershelf/debian:wheezy`](https://hub.docker.com/r/dockershelf/debian)|`wheezy`|[![](https://img.shields.io/badge/-debian%2Fwheezy%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/debian/wheezy/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/debian:wheezy.svg)](https://microbadger.com/images/dockershelf/debian:wheezy)|
|[`dockershelf/debian:jessie`](https://hub.docker.com/r/dockershelf/debian)|`jessie`|[![](https://img.shields.io/badge/-debian%2Fjessie%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/debian/jessie/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/debian:jessie.svg)](https://microbadger.com/images/dockershelf/debian:jessie)|
|[`dockershelf/debian:stretch`](https://hub.docker.com/r/dockershelf/debian)|`stretch`|[![](https://img.shields.io/badge/-debian%2Fstretch%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/debian/stretch/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/debian:stretch.svg)](https://microbadger.com/images/dockershelf/debian:stretch)|
|[`dockershelf/debian:buster`](https://hub.docker.com/r/dockershelf/debian)|`buster`|[![](https://img.shields.io/badge/-debian%2Fbuster%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/debian/buster/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/debian:buster.svg)](https://microbadger.com/images/dockershelf/debian:buster)|
|[`dockershelf/debian:sid`](https://hub.docker.com/r/dockershelf/debian)|`sid`|[![](https://img.shields.io/badge/-debian%2Fsid%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/debian/sid/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/debian:sid.svg)](https://microbadger.com/images/dockershelf/debian:sid)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

### Latex

This is a Latex image built with the following packages installed: `texlive-fonts-recommended`, `texlive-latex-base`, `texlive-latex-extra` and `latex-xcolor`. It should be enough to use the `pdflatex` binary for basic Latex to PDF conversion. Check out [latex/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/latex/README.md) for more details.

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`dockershelf/latex:sid`](https://hub.docker.com/r/dockershelf/latex)|`sid`|[![](https://img.shields.io/badge/-latex%2Fsid%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/latex/sid/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/latex:sid.svg)](https://microbadger.com/images/dockershelf/latex:sid)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

### Python

These are python images with native debian packages that are extracted from different debian releases. Check out [python/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/python/README.md) for more details.

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`2.6`](https://hub.docker.com/r/dockershelf/python)|`2.6`|[![](https://img.shields.io/badge/-python%2F2.6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/2.6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:2.6.svg)](https://microbadger.com/images/dockershelf/python:2.6)|
|[`2.7`](https://hub.docker.com/r/dockershelf/python)|`2.7`|[![](https://img.shields.io/badge/-python%2F2.7%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/2.7/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:2.7.svg)](https://microbadger.com/images/dockershelf/python:2.7)|
|[`3.2`](https://hub.docker.com/r/dockershelf/python)|`3.2`|[![](https://img.shields.io/badge/-python%2F3.2%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.2/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.2.svg)](https://microbadger.com/images/dockershelf/python:3.2)|
|[`3.4`](https://hub.docker.com/r/dockershelf/python)|`3.4`|[![](https://img.shields.io/badge/-python%2F3.4%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.4/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.4.svg)](https://microbadger.com/images/dockershelf/python:3.4)|
|[`3.5`](https://hub.docker.com/r/dockershelf/python)|`3.5`|[![](https://img.shields.io/badge/-python%2F3.5%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.5/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.5.svg)](https://microbadger.com/images/dockershelf/python:3.5)|
|[`3.6`](https://hub.docker.com/r/dockershelf/python)|`3.6`|[![](https://img.shields.io/badge/-python%2F3.6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.6.svg)](https://microbadger.com/images/dockershelf/python:3.6)|
|[`3.7`](https://hub.docker.com/r/dockershelf/python)|`3.7`|[![](https://img.shields.io/badge/-python%2F3.7%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.7/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.7.svg)](https://microbadger.com/images/dockershelf/python:3.7)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

### Ruby

These are ruby images with native debian packages that are extracted from different debian releases. Check out [ruby/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/README.md) for more details.

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`1.8`](https://hub.docker.com/r/dockershelf/ruby)|`1.8`|[![](https://img.shields.io/badge/-ruby%2F1.8%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/1.8/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:1.8.svg)](https://microbadger.com/images/dockershelf/ruby:1.8)|
|[`1.9.1`](https://hub.docker.com/r/dockershelf/ruby)|`1.9.1`|[![](https://img.shields.io/badge/-ruby%2F1.9.1%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/1.9.1/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:1.9.1.svg)](https://microbadger.com/images/dockershelf/ruby:1.9.1)|
|[`2.1`](https://hub.docker.com/r/dockershelf/ruby)|`2.1`|[![](https://img.shields.io/badge/-ruby%2F2.1%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/2.1/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:2.1.svg)](https://microbadger.com/images/dockershelf/ruby:2.1)|
|[`2.3`](https://hub.docker.com/r/dockershelf/ruby)|`2.3`|[![](https://img.shields.io/badge/-ruby%2F2.3%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/2.3/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:2.3.svg)](https://microbadger.com/images/dockershelf/ruby:2.3)|
|[`2.5`](https://hub.docker.com/r/dockershelf/ruby)|`2.5`|[![](https://img.shields.io/badge/-ruby%2F2.5%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/2.5/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:2.5.svg)](https://microbadger.com/images/dockershelf/ruby:2.5)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

### Node

These are Node images built using the [nodesource installation scripts](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions). Check out [node/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/node/README.md) for more details.

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`dockershelf/node:6`](https://hub.docker.com/r/dockershelf/node)|`6`|[![](https://img.shields.io/badge/-node%2F6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:6.svg)](https://microbadger.com/images/dockershelf/node:6)|
|[`dockershelf/node:7`](https://hub.docker.com/r/dockershelf/node)|`7`|[![](https://img.shields.io/badge/-node%2F7%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/7/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:7.svg)](https://microbadger.com/images/dockershelf/node:7)|
|[`dockershelf/node:4`](https://hub.docker.com/r/dockershelf/node)|`4`|[![](https://img.shields.io/badge/-node%2F4%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/4/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:4.svg)](https://microbadger.com/images/dockershelf/node:4)|
|[`dockershelf/node:8`](https://hub.docker.com/r/dockershelf/node)|`8`|[![](https://img.shields.io/badge/-node%2F8%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/8/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:8.svg)](https://microbadger.com/images/dockershelf/node:8)|
|[`dockershelf/node:9`](https://hub.docker.com/r/dockershelf/node)|`9`|[![](https://img.shields.io/badge/-node%2F9%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/9/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:9.svg)](https://microbadger.com/images/dockershelf/node:9)|
|[`dockershelf/node:10`](https://hub.docker.com/r/dockershelf/node)|`10`|[![](https://img.shields.io/badge/-node%2F10%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/10/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:10.svg)](https://microbadger.com/images/dockershelf/node:10)|
|[`dockershelf/node:5`](https://hub.docker.com/r/dockershelf/node)|`5`|[![](https://img.shields.io/badge/-node%2F5%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/5/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:5.svg)](https://microbadger.com/images/dockershelf/node:5)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

### Mongo

These are Mongo images built using the [official installation guide](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/). Check out [mongo/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/README.md) for more details.

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`dockershelf/mongo:3.2`](https://hub.docker.com/r/dockershelf/mongo)|`3.2`|[![](https://img.shields.io/badge/-mongo%2F3.2%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/3.2/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/mongo:3.2.svg)](https://microbadger.com/images/dockershelf/mongo:3.2)|
|[`dockershelf/mongo:3.4`](https://hub.docker.com/r/dockershelf/mongo)|`3.4`|[![](https://img.shields.io/badge/-mongo%2F3.4%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/3.4/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/mongo:3.4.svg)](https://microbadger.com/images/dockershelf/mongo:3.4)|
|[`dockershelf/mongo:3.6`](https://hub.docker.com/r/dockershelf/mongo)|`3.6`|[![](https://img.shields.io/badge/-mongo%2F3.6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/3.6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/mongo:3.6.svg)](https://microbadger.com/images/dockershelf/mongo:3.6)|
|[`dockershelf/mongo:4.0`](https://hub.docker.com/r/dockershelf/mongo)|`4.0`|[![](https://img.shields.io/badge/-mongo%2F4.0%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/4.0/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/mongo:4.0.svg)](https://microbadger.com/images/dockershelf/mongo:4.0)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

### Postgres

These are PostgreSQL images built using the [official installation guide](https://www.postgresql.org/download/linux/debian/). Check out [postgres/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/README.md) for more details.

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`dockershelf/postgres:9.3`](https://hub.docker.com/r/dockershelf/postgres)|`9.3`|[![](https://img.shields.io/badge/-postgres%2F9.3%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/9.3/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:9.3.svg)](https://microbadger.com/images/dockershelf/postgres:9.3)|
|[`dockershelf/postgres:9.4`](https://hub.docker.com/r/dockershelf/postgres)|`9.4`|[![](https://img.shields.io/badge/-postgres%2F9.4%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/9.4/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:9.4.svg)](https://microbadger.com/images/dockershelf/postgres:9.4)|
|[`dockershelf/postgres:9.5`](https://hub.docker.com/r/dockershelf/postgres)|`9.5`|[![](https://img.shields.io/badge/-postgres%2F9.5%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/9.5/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:9.5.svg)](https://microbadger.com/images/dockershelf/postgres:9.5)|
|[`dockershelf/postgres:9.6`](https://hub.docker.com/r/dockershelf/postgres)|`9.6`|[![](https://img.shields.io/badge/-postgres%2F9.6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/9.6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:9.6.svg)](https://microbadger.com/images/dockershelf/postgres:9.6)|
|[`dockershelf/postgres:10`](https://hub.docker.com/r/dockershelf/postgres)|`10`|[![](https://img.shields.io/badge/-postgres%2F10%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/10/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:10.svg)](https://microbadger.com/images/dockershelf/postgres:10)|
|[`dockershelf/postgres:11`](https://hub.docker.com/r/dockershelf/postgres)|`11`|[![](https://img.shields.io/badge/-postgres%2F11%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/11/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:11.svg)](https://microbadger.com/images/dockershelf/postgres:11)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

## How to download

Pull one of the available images and start hacking!

```bash
docker pull [docker image name]
docker run -it [docker image name] bash
```
<sup>[docker image name] is the desired image to download.</sup>

## How to build locally

Clone this repository to your machine.

```bash
git clone https://github.com/LuisAlejandro/dockershelf
```

Run the build script in the root folder of your local copy. Remember to have docker installed and make sure your user has proper privileges to execute `docker build`.

```bash
bash build-image.sh [docker image name]
```

<sup>[docker image name] is the desired image to build.</sup>

## Made with :heart: and :hamburger:

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro), [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.me/martinezfaneyth), so that I can continue doing what I love.

> Blog [huntingbears.com.ve](http://huntingbears.com.ve) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)