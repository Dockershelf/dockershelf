![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/travis/Dockershelf/dockershelf.svg)](https://travis-ci.org/Dockershelf/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/debian.svg)](https://hub.docker.com/r/dockershelf/debian) [![](https://img.shields.io/github/issues-raw/Dockershelf/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/Dockershelf/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/Dockershelf/dockershelf.svg)](https://gitter.im/Dockershelf/dockershelf) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Latex shelf

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/latex:basic`](https://hub.docker.com/r/dockershelf/latex)|`basic`|[![](https://img.shields.io/badge/-latex%2Fbasic%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/basic/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/basic.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|
|[`dockershelf/latex:full`](https://hub.docker.com/r/dockershelf/latex)|`full`|[![](https://img.shields.io/badge/-latex%2Ffull%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/full/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/full.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|

![](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/table.svg)

## Building process

The Latex images are very simple, they're just debian images with `texlive-fonts-recommended`, `texlive-latex-base`, `texlive-latex-extra` and `latex-xcolor` debian packages installed. Check out the [Dockerfile](https://github.com/Dockershelf/dockershelf/blob/master/latex/sid/Dockerfile) for details.

## Made with :heart: and :hamburger:

![Banner](https://rawcdn.githack.com/Dockershelf/dockershelf/91d2963fe6771cf92350fd81b27572370381b074/images/promo-open-source.svg)

> Web [collagelabs.org](http://collagelabs.org/) · GitHub [@CollageLabs](https://github.com/CollageLabs) · Twitter [@CollageLabs](https://twitter.com/CollageLabs)