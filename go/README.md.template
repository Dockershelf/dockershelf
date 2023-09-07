![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/github/workflow/status/Dockershelf/dockershelf/Schedule%20(master%20branch)?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/actions/workflows/schedule-master.yml) [![](https://img.shields.io/docker/pulls/dockershelf/python.svg?cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python) [![](https://img.shields.io/discord/809504357359157288?cacheSeconds=900)](https://discord.gg/4Wc7xphH5e) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Python shelf

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
%%PYTHON_TABLE%%

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

## Building process

The Python images are built using a bash script [`python/build-image.sh`](https://github.com/Dockershelf/dockershelf/blob/master/python/build-image.sh), you can check it out for details.

Each python release is downloaded and installed from the [deadsnakes ppa](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa).

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:<release>`.
2. Labelled according to [label-schema.org](http://label-schema.org) and [opencontainers specification](https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys).
3. Install developer tools to handle the package installation.
4. Install Python.
5. Uninstall developer tools and orphan packages.
6. Install `pip`.
7. Shrink image by deleting unnecessary files.

## Made with 💖 and 🍔

![Banner](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/author-banner.svg)

> Web [luisalejandro.org](http://luisalejandro.org/) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)