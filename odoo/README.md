![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/travis/Dockershelf/dockershelf.svg)](https://travis-ci.org/Dockershelf/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/odoo.svg)](https://hub.docker.com/r/dockershelf/odoo) [![](https://img.shields.io/github/issues-raw/Dockershelf/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/Dockershelf/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/Dockershelf/dockershelf.svg)](https://gitter.im/Dockershelf/dockershelf) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Odoo shelf

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/odoo:11.0`](https://hub.docker.com/r/dockershelf/odoo)|`11.0`|[![](https://img.shields.io/badge/-odoo%2F11.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/11.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/11.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:12.0`](https://hub.docker.com/r/dockershelf/odoo)|`12.0`|[![](https://img.shields.io/badge/-odoo%2F12.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/12.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/12.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:13.0`](https://hub.docker.com/r/dockershelf/odoo)|`13.0`|[![](https://img.shields.io/badge/-odoo%2F13.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/13.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/13.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:14.0`](https://hub.docker.com/r/dockershelf/odoo)|`14.0`|[![](https://img.shields.io/badge/-odoo%2F14.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/14.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/14.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

## Building process

The Python images are built using a bash script [`odoo/build-image.sh`](https://github.com/Dockershelf/dockershelf/blob/master/odoo/build-image.sh), you can check it out for details.

Each node release is installed using the [Odoo official installation guide](https://www.odoo.com/documentation/11.0/setup/install.html).

We'll explain the overall process here:

1. Built `FROM dockershelf/python:3.5`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the package installation.
4. Install Odoo.
5. Uninstall developer tools and orphan packages.
6. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/promo-open-source.svg)

> Web [collagelabs.org](http://collagelabs.org/) · GitHub [@CollageLabs](https://github.com/CollageLabs) · Twitter [@CollageLabs](https://twitter.com/CollageLabs)