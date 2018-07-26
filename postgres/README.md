![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/postgres.svg)](https://hub.docker.com/r/dockershelf/postgres) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

## Postgres shelf

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`dockershelf/postgres:9.3`](https://hub.docker.com/r/dockershelf/postgres)|`9.3`|[![](https://img.shields.io/badge/-postgres%2F9.3%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/9.3/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:9.3.svg)](https://microbadger.com/images/dockershelf/postgres:9.3)|
|[`dockershelf/postgres:9.4`](https://hub.docker.com/r/dockershelf/postgres)|`9.4`|[![](https://img.shields.io/badge/-postgres%2F9.4%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/9.4/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:9.4.svg)](https://microbadger.com/images/dockershelf/postgres:9.4)|
|[`dockershelf/postgres:9.5`](https://hub.docker.com/r/dockershelf/postgres)|`9.5`|[![](https://img.shields.io/badge/-postgres%2F9.5%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/9.5/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:9.5.svg)](https://microbadger.com/images/dockershelf/postgres:9.5)|
|[`dockershelf/postgres:9.6`](https://hub.docker.com/r/dockershelf/postgres)|`9.6`|[![](https://img.shields.io/badge/-postgres%2F9.6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/9.6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:9.6.svg)](https://microbadger.com/images/dockershelf/postgres:9.6)|
|[`dockershelf/postgres:10`](https://hub.docker.com/r/dockershelf/postgres)|`10`|[![](https://img.shields.io/badge/-postgres%2F10%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/10/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:10.svg)](https://microbadger.com/images/dockershelf/postgres:10)|
|[`dockershelf/postgres:11`](https://hub.docker.com/r/dockershelf/postgres)|`11`|[![](https://img.shields.io/badge/-postgres%2F11%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/11/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:11.svg)](https://microbadger.com/images/dockershelf/postgres:11)|
|[`dockershelf/postgres:12`](https://hub.docker.com/r/dockershelf/postgres)|`12`|[![](https://img.shields.io/badge/-postgres%2F12%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/12/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/postgres:12.svg)](https://microbadger.com/images/dockershelf/postgres:12)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

## Building process

The Postgres images are built using a bash script [`postgres/build-image.sh`](https://github.com/LuisAlejandro/dockershelf/blob/master/postgres/build-image.sh), you can check it out for details.

Each postgres release is installed using the [official installation guide](https://www.postgresql.org/download/linux/debian/).

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:sid`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the packages installation.
5. Configure postgresdb user and data/config directories.
4. Install Postgres.
5. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro), [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.me/martinezfaneyth), so that I can continue doing what I love.

> Blog [huntingbears.com.ve](http://huntingbears.com.ve) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)