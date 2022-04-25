![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/github/workflow/status/Dockershelf/dockershelf/Schedule%20(master%20branch)?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/actions/workflows/schedule-master.yml) [![](https://img.shields.io/docker/pulls/dockershelf/php.svg?cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php) [![](https://img.shields.io/discord/809504357359157288?cacheSeconds=900)](https://discord.gg/4Wc7xphH5e) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## PHP shelf

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/php:7.0`](https://hub.docker.com/r/dockershelf/php)|`7.0`|[![](https://img.shields.io/badge/-php%2F7.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:7.3`](https://hub.docker.com/r/dockershelf/php)|`7.3`|[![](https://img.shields.io/badge/-php%2F7.3%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.3/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.3.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:7.4`](https://hub.docker.com/r/dockershelf/php)|`7.4`|[![](https://img.shields.io/badge/-php%2F7.4%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.4/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/7.4.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|
|[`dockershelf/php:8.1`](https://hub.docker.com/r/dockershelf/php)|`8.1`|[![](https://img.shields.io/badge/-php%2F8.1%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/8.1/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/php?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|[![](https://img.shields.io/docker/image-size/dockershelf/php/8.1.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/php)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

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

![Banner](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/author-banner.svg)

> Web [luisalejandro.org](http://luisalejandro.org/) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)