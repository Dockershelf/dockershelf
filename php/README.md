![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/travis/Dockershelf/dockershelf.svg)](https://travis-ci.org/Dockershelf/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/php.svg)](https://hub.docker.com/r/dockershelf/php) [![](https://img.shields.io/github/issues-raw/Dockershelf/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/Dockershelf/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/Dockershelf/dockershelf.svg)](https://gitter.im/Dockershelf/dockershelf) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## PHP shelf

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/php:7.0`](https://hub.docker.com/r/dockershelf/php)|`7.0`|[![](https://img.shields.io/badge/-php%2F7.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:7.2`](https://hub.docker.com/r/dockershelf/php)|`7.2`|[![](https://img.shields.io/badge/-php%2F7.2%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.2/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.2.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:7.3`](https://hub.docker.com/r/dockershelf/php)|`7.3`|[![](https://img.shields.io/badge/-php%2F7.3%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.3/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.3.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:7.4`](https://hub.docker.com/r/dockershelf/php)|`7.4`|[![](https://img.shields.io/badge/-php%2F7.4%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.4/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.4.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:8.0`](https://hub.docker.com/r/dockershelf/php)|`8.0`|[![](https://img.shields.io/badge/-php%2F8.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/8.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/8.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

## Building process

The PHP images are built using a bash script [`php/build-image.sh`](https://github.com/Dockershelf/dockershelf/blob/master/php/build-image.sh), you can check it out for details.

Each php release is downloaded and installed from the debian official repositories. Some releases are not compiled against Debian Sid libraries, so some potentially old libraries could be installed in the process.

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:sid`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the package installation.
4. Install PHP.
5. Uninstall developer tools and orphan packages.
6. Install `pip`.
7. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/promo-open-source.svg)

> Web [collagelabs.org](http://collagelabs.org/) · GitHub [@CollageLabs](https://github.com/CollageLabs) · Twitter [@CollageLabs](https://twitter.com/CollageLabs)