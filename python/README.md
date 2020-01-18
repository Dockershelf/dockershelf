![](https://rawcdn.githack.com/Dockershelf/dockershelf/d97c0e447644f70a8ec62a2a84b49e4438513cbf/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/travis/Dockershelf/dockershelf.svg)](https://travis-ci.org/Dockershelf/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/python.svg)](https://hub.docker.com/r/dockershelf/python) [![](https://img.shields.io/github/issues-raw/Dockershelf/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/Dockershelf/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/Dockershelf/dockershelf.svg)](https://gitter.im/Dockershelf/dockershelf) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Python shelf

|Image  |Release  |Dockerfile  |Layers  |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/python:2.7`](https://hub.docker.com/r/dockershelf/python)|`2.7`|[![](https://img.shields.io/badge/-python%2F2.7%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/2.7/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/python/2.7.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:2.7)|[![](https://img.shields.io/microbadger/image-size/dockershelf/python/2.7.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:2.7)|
|[`dockershelf/python:3.5`](https://hub.docker.com/r/dockershelf/python)|`3.5`|[![](https://img.shields.io/badge/-python%2F3.5%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.5/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/python/3.5.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:3.5)|[![](https://img.shields.io/microbadger/image-size/dockershelf/python/3.5.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:3.5)|
|[`dockershelf/python:3.6`](https://hub.docker.com/r/dockershelf/python)|`3.6`|[![](https://img.shields.io/badge/-python%2F3.6%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.6/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/python/3.6.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:3.6)|[![](https://img.shields.io/microbadger/image-size/dockershelf/python/3.6.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:3.6)|
|[`dockershelf/python:3.7`](https://hub.docker.com/r/dockershelf/python)|`3.7`|[![](https://img.shields.io/badge/-python%2F3.7%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.7/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/python/3.7.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:3.7)|[![](https://img.shields.io/microbadger/image-size/dockershelf/python/3.7.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:3.7)|
|[`dockershelf/python:3.8`](https://hub.docker.com/r/dockershelf/python)|`3.8`|[![](https://img.shields.io/badge/-python%2F3.8%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.8/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/python/3.8.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:3.8)|[![](https://img.shields.io/microbadger/image-size/dockershelf/python/3.8.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/python:3.8)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/42161077720b74d46b2ed8e51cb5bb958bb0406a/images/table.svg)

## Building process

The Python images are built using a bash script [`python/build-image.sh`](https://github.com/Dockershelf/dockershelf/blob/master/python/build-image.sh), you can check it out for details.

Each python release is downloaded and installed from the debian official repositories. Some releases are not compiled against Debian Sid libraries, so some potentially old libraries could be installed in the process.

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:sid`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the package installation.
4. Install Python.
5. Uninstall developer tools and orphan packages.
6. Install `pip`.
7. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](https://rawcdn.githack.com/Dockershelf/dockershelf/42161077720b74d46b2ed8e51cb5bb958bb0406a/images/promo-open-source.svg)

> Web [collagelabs.org](http://collagelabs.org/) · GitHub [@CollageLabs](https://github.com/CollageLabs) · Twitter [@CollageLabs](https://twitter.com/CollageLabs)