![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/travis/Dockershelf/dockershelf.svg)](https://travis-ci.org/Dockershelf/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/ruby.svg)](https://hub.docker.com/r/dockershelf/ruby) [![](https://img.shields.io/github/issues-raw/Dockershelf/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/Dockershelf/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/Dockershelf/dockershelf.svg)](https://gitter.im/Dockershelf/dockershelf) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Ruby shelf

|Image  |Release  |Dockerfile  |Layers  |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/ruby:2.1`](https://hub.docker.com/r/dockershelf/ruby)|`2.1`|[![](https://img.shields.io/badge/-ruby%2F2.1%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/ruby/2.1/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/ruby/2.1.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120)](https://microbadger.com/images/dockershelf/ruby:2.1)|[![](https://img.shields.io/docker/image-size/dockershelf/ruby/2.1.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120)](https://microbadger.com/images/dockershelf/ruby:2.1)|
|[`dockershelf/ruby:2.3`](https://hub.docker.com/r/dockershelf/ruby)|`2.3`|[![](https://img.shields.io/badge/-ruby%2F2.3%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/ruby/2.3/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/ruby/2.3.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120)](https://microbadger.com/images/dockershelf/ruby:2.3)|[![](https://img.shields.io/docker/image-size/dockershelf/ruby/2.3.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120)](https://microbadger.com/images/dockershelf/ruby:2.3)|
|[`dockershelf/ruby:2.5`](https://hub.docker.com/r/dockershelf/ruby)|`2.5`|[![](https://img.shields.io/badge/-ruby%2F2.5%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/ruby/2.5/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/ruby/2.5.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120)](https://microbadger.com/images/dockershelf/ruby:2.5)|[![](https://img.shields.io/docker/image-size/dockershelf/ruby/2.5.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120)](https://microbadger.com/images/dockershelf/ruby:2.5)|
|[`dockershelf/ruby:2.7`](https://hub.docker.com/r/dockershelf/ruby)|`2.7`|[![](https://img.shields.io/badge/-ruby%2F2.7%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/ruby/2.7/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/ruby/2.7.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120)](https://microbadger.com/images/dockershelf/ruby:2.7)|[![](https://img.shields.io/docker/image-size/dockershelf/ruby/2.7.svg?colorA=22313f&colorB=4a637b&cacheSeconds=120)](https://microbadger.com/images/dockershelf/ruby:2.7)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

## Building process

The Ruby images are built using a bash script [`ruby/build-image.sh`](https://github.com/Dockershelf/dockershelf/blob/master/ruby/build-image.sh), you can check it out for details.

Each ruby release is downloaded and installed from the debian official repositories. Some releases are not compiled against Debian Sid libraries, so some potentially old libraries could be installed in the process.

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:sid`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the package installation.
4. Install Ruby.
5. Uninstall developer tools and orphan packages.
6. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/promo-open-source.svg)

> Web [collagelabs.org](http://collagelabs.org/) · GitHub [@CollageLabs](https://github.com/CollageLabs) · Twitter [@CollageLabs](https://twitter.com/CollageLabs)