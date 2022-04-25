![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/github/workflow/status/Dockershelf/dockershelf/Schedule%20(master%20branch)?cacheSeconds=900)](https://github.com/Dockershelf/dockershelf/actions/workflows/schedule-master.yml) [![](https://img.shields.io/docker/pulls/dockershelf/postgres.svg?cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres) [![](https://img.shields.io/discord/809504357359157288?cacheSeconds=900)](https://discord.gg/4Wc7xphH5e) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Postgres shelf

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/postgres:10`](https://hub.docker.com/r/dockershelf/postgres)|`10`|[![](https://img.shields.io/badge/-postgres%2F10%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/10/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/10.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|
|[`dockershelf/postgres:11`](https://hub.docker.com/r/dockershelf/postgres)|`11`|[![](https://img.shields.io/badge/-postgres%2F11%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/11/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/11.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|
|[`dockershelf/postgres:12`](https://hub.docker.com/r/dockershelf/postgres)|`12`|[![](https://img.shields.io/badge/-postgres%2F12%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/12/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/12.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|
|[`dockershelf/postgres:13`](https://hub.docker.com/r/dockershelf/postgres)|`13`|[![](https://img.shields.io/badge/-postgres%2F13%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/13/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/13.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|
|[`dockershelf/postgres:14`](https://hub.docker.com/r/dockershelf/postgres)|`14`|[![](https://img.shields.io/badge/-postgres%2F14%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/postgres/14/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/postgres?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|[![](https://img.shields.io/docker/image-size/dockershelf/postgres/14.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/postgres)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

## Building process

The Postgres images are built using a bash script [`postgres/build-image.sh`](https://github.com/Dockershelf/dockershelf/blob/master/postgres/build-image.sh), you can check it out for details.

Each postgres release is installed using the [official installation guide](https://www.postgresql.org/download/linux/debian/).

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:sid`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the packages installation.
4. Configure postgres user and data/config directories.
5. Install Postgres.
6. Shrink image by deleting unnecessary files.

## Made with 💖 and 🍔

![Banner](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/author-banner.svg)

> Web [luisalejandro.org](http://luisalejandro.org/) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)