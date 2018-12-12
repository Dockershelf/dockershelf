![](https://cdn.rawgit.com/LuisAlejandro/dockershelf/master/images/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/mongo.svg)](https://hub.docker.com/r/dockershelf/mongo) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

## Mongo shelf

|Image  |Release  |Dockerfile  |Layers  |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/mongo:3.4`](https://hub.docker.com/r/dockershelf/mongo)|`3.4`|[![](https://img.shields.io/badge/-mongo%2F3.4%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/3.4/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/mongo/3.4.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:3.4)|[![](https://img.shields.io/microbadger/image-size/dockershelf/mongo/3.4.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:3.4)|
|[`dockershelf/mongo:3.6`](https://hub.docker.com/r/dockershelf/mongo)|`3.6`|[![](https://img.shields.io/badge/-mongo%2F3.6%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/3.6/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/mongo/3.6.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:3.6)|[![](https://img.shields.io/microbadger/image-size/dockershelf/mongo/3.6.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:3.6)|
|[`dockershelf/mongo:4.0`](https://hub.docker.com/r/dockershelf/mongo)|`4.0`|[![](https://img.shields.io/badge/-mongo%2F4.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/4.0/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/mongo/4.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:4.0)|[![](https://img.shields.io/microbadger/image-size/dockershelf/mongo/4.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/mongo:4.0)|

![](https://cdn.rawgit.com/LuisAlejandro/dockershelf/master/images/table.svg)

## Building process

The Mongo images are built using a bash script [`mongo/build-image.sh`](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/build-image.sh), you can check it out for details.

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

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro), [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.me/martinezfaneyth), so that I can continue doing what I love.

> Blog [luisalejandro.org](http://luisalejandro.org) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)