![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/github/workflow/status/Dockershelf/dockershelf/Schedule%20(master%20branch)?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/actions/workflows/schedule-master.yml) [![](https://img.shields.io/docker/pulls/dockershelf/mongo.svg?cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo) [![](https://img.shields.io/discord/809504357359157288?cacheSeconds=900)](https://discord.gg/4Wc7xphH5e) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Mongo shelf

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/mongo:4.2`](https://hub.docker.com/r/dockershelf/mongo)|`4.2`|[![](https://img.shields.io/badge/-mongo%2F4.2%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/4.2/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/mongo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|[![](https://img.shields.io/docker/image-size/dockershelf/mongo/4.2.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|
|[`dockershelf/mongo:4.4`](https://hub.docker.com/r/dockershelf/mongo)|`4.4`|[![](https://img.shields.io/badge/-mongo%2F4.4%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/4.4/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/mongo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|[![](https://img.shields.io/docker/image-size/dockershelf/mongo/4.4.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|
|[`dockershelf/mongo:5.0`](https://hub.docker.com/r/dockershelf/mongo)|`5.0`|[![](https://img.shields.io/badge/-mongo%2F5.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/mongo/5.0/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/mongo?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|[![](https://img.shields.io/docker/image-size/dockershelf/mongo/5.0.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/mongo)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

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

![Banner](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/author-banner.svg)

> Web [luisalejandro.org](http://luisalejandro.org/) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)