![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/github/workflow/status/Dockershelf/dockershelf/Schedule%20(master%20branch)?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/actions/workflows/schedule-master.yml) [![](https://img.shields.io/docker/pulls/dockershelf/latex.svg?cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex) [![](https://img.shields.io/discord/809504357359157288?cacheSeconds=900)](https://discord.gg/4Wc7xphH5e) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Latex shelf

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/latex:basic`](https://hub.docker.com/r/dockershelf/latex)|`basic`|[![](https://img.shields.io/badge/-latex%2Fbasic%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/basic/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/basic.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|
|[`dockershelf/latex:full`](https://hub.docker.com/r/dockershelf/latex)|`full`|[![](https://img.shields.io/badge/-latex%2Ffull%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/full/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/full.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

## Building process

The Latex images are very simple, they're just debian images with `texlive-fonts-recommended`, `texlive-latex-base`, `texlive-latex-extra` and `latex-xcolor` debian packages installed. Check out the [Dockerfile](https://github.com/Dockershelf/dockershelf/blob/master/latex/sid/Dockerfile) for details.

## Made with 💖 and 🍔

![Banner](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/author-banner.svg)

> Web [luisalejandro.org](http://luisalejandro.org/) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)