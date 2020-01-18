![](https://cdn.rawgit.com/LuisAlejandro/dockershelf/master/images/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/php.svg)](https://hub.docker.com/r/dockershelf/php) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/Dockershelf/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

## PHP shelf

|Image  |Release  |Dockerfile  |Layers  |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/php:7.0`](https://hub.docker.com/r/dockershelf/php)|`7.0`|[![](https://img.shields.io/badge/-php%2F7.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.0/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/php/7.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/php:7.0)|[![](https://img.shields.io/microbadger/image-size/dockershelf/php/7.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/php:7.0)|
|[`dockershelf/php:7.2`](https://hub.docker.com/r/dockershelf/php)|`7.2`|[![](https://img.shields.io/badge/-php%2F7.2%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.2/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/php/7.2.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/php:7.2)|[![](https://img.shields.io/microbadger/image-size/dockershelf/php/7.2.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/php:7.2)|
|[`dockershelf/php:7.3`](https://hub.docker.com/r/dockershelf/php)|`7.3`|[![](https://img.shields.io/badge/-php%2F7.3%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.3/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/php/7.3.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/php:7.3)|[![](https://img.shields.io/microbadger/image-size/dockershelf/php/7.3.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/php:7.3)|
|[`dockershelf/php:7.4`](https://hub.docker.com/r/dockershelf/php)|`7.4`|[![](https://img.shields.io/badge/-php%2F7.4%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/php/7.4/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/php/7.4.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/php:7.4)|[![](https://img.shields.io/microbadger/image-size/dockershelf/php/7.4.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/php:7.4)|

![](https://cdn.rawgit.com/LuisAlejandro/dockershelf/master/images/table.svg)

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

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro), [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.me/martinezfaneyth), so that I can continue doing what I love.

> Blog [luisalejandro.org](http://luisalejandro.org) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)