![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/github/workflow/status/Dockershelf/dockershelf/Schedule%20(master%20branch)?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/actions/workflows/schedule-master.yml) [![](https://img.shields.io/docker/pulls/dockershelf/odoo.svg?cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo) [![](https://img.shields.io/discord/809504357359157288?cacheSeconds=900)](https://discord.gg/4Wc7xphH5e) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Odoo shelf

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/odoo:11.0`](https://hub.docker.com/r/dockershelf/odoo)|`11.0`|[![](https://img.shields.io/badge/-odoo%2F11.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/11.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/11.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:12.0`](https://hub.docker.com/r/dockershelf/odoo)|`12.0`|[![](https://img.shields.io/badge/-odoo%2F12.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/12.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/12.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:13.0`](https://hub.docker.com/r/dockershelf/odoo)|`13.0`|[![](https://img.shields.io/badge/-odoo%2F13.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/13.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/13.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:14.0`](https://hub.docker.com/r/dockershelf/odoo)|`14.0`|[![](https://img.shields.io/badge/-odoo%2F14.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/14.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/14.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|
|[`dockershelf/odoo:15.0`](https://hub.docker.com/r/dockershelf/odoo)|`15.0`|[![](https://img.shields.io/badge/-odoo%2F15.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/odoo/15.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/odoo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|[![](https://img.shields.io/docker/image-size/dockershelf/odoo/15.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/odoo)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

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

![Banner](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/author-banner.svg)

> Web [luisalejandro.org](http://luisalejandro.org/) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)