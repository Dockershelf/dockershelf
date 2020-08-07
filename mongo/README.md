![](https://rawcdn.githack.com/Dockershelf/dockershelf/4db25518b4ed4507a278c56575072649fc52503a/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/travis/Dockershelf/dockershelf.svg)](https://travis-ci.org/Dockershelf/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/mongo.svg)](https://hub.docker.com/r/dockershelf/mongo) [![](https://img.shields.io/github/issues-raw/Dockershelf/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/Dockershelf/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/Dockershelf/dockershelf.svg)](https://gitter.im/Dockershelf/dockershelf) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Mongo shelf

|Image  |Release  |Dockerfile  |Layers  |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/mongo:3.6`](https://hub.docker.com/r/dockershelf/mongo)|`3.6`|[![](https://img.shields.io/badge/-mongo%2F3.6%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/3.6/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/mongo/3.6.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:3.6)|[![](https://img.shields.io/microbadger/image-size/dockershelf/mongo/3.6.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:3.6)|
|[`dockershelf/mongo:4.0`](https://hub.docker.com/r/dockershelf/mongo)|`4.0`|[![](https://img.shields.io/badge/-mongo%2F4.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/4.0/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/mongo/4.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:4.0)|[![](https://img.shields.io/microbadger/image-size/dockershelf/mongo/4.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:4.0)|
|[`dockershelf/mongo:4.2`](https://hub.docker.com/r/dockershelf/mongo)|`4.2`|[![](https://img.shields.io/badge/-mongo%2F4.2%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/4.2/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/mongo/4.2.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:4.2)|[![](https://img.shields.io/microbadger/image-size/dockershelf/mongo/4.2.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:4.2)|
|[`dockershelf/mongo:4.4`](https://hub.docker.com/r/dockershelf/mongo)|`4.4`|[![](https://img.shields.io/badge/-mongo%2F4.4%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/4.4/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/mongo/4.4.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:4.4)|[![](https://img.shields.io/microbadger/image-size/dockershelf/mongo/4.4.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:4.4)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/42161077720b74d46b2ed8e51cb5bb958bb0406a/images/table.svg)

## Building process

The Mongo images are built using a bash script [`mongo/build-image.sh`](https://github.com/Dockershelf/dockershelf/blob/master/mongo/build-image.sh), you can check it out for details.

Each mongo release is installed using the [official installation guide](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/).

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:sid`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the packages installation.
4. Configure `/etc/apt/sources.list` to add the official mongo repository according to the version.
5. Install runtime dependencies.
6. Configure mongodb user and data/config directories.
7. Install Mongo.
8. Shrink image by deleting unnecessary files and/or packages.

## Made with :heart: and :hamburger:

![Banner](https://rawcdn.githack.com/Dockershelf/dockershelf/42161077720b74d46b2ed8e51cb5bb958bb0406a/images/promo-open-source.svg)

> Web [collagelabs.org](http://collagelabs.org/) · GitHub [@CollageLabs](https://github.com/CollageLabs) · Twitter [@CollageLabs](https://twitter.com/CollageLabs)