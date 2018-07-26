![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/node.svg)](https://hub.docker.com/r/dockershelf/node) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

## Node shelf

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`dockershelf/node:6`](https://hub.docker.com/r/dockershelf/node)|`6`|[![](https://img.shields.io/badge/-node%2F6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:6.svg)](https://microbadger.com/images/dockershelf/node:6)|
|[`dockershelf/node:7`](https://hub.docker.com/r/dockershelf/node)|`7`|[![](https://img.shields.io/badge/-node%2F7%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/7/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:7.svg)](https://microbadger.com/images/dockershelf/node:7)|
|[`dockershelf/node:4`](https://hub.docker.com/r/dockershelf/node)|`4`|[![](https://img.shields.io/badge/-node%2F4%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/4/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:4.svg)](https://microbadger.com/images/dockershelf/node:4)|
|[`dockershelf/node:8`](https://hub.docker.com/r/dockershelf/node)|`8`|[![](https://img.shields.io/badge/-node%2F8%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/8/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:8.svg)](https://microbadger.com/images/dockershelf/node:8)|
|[`dockershelf/node:9`](https://hub.docker.com/r/dockershelf/node)|`9`|[![](https://img.shields.io/badge/-node%2F9%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/9/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:9.svg)](https://microbadger.com/images/dockershelf/node:9)|
|[`dockershelf/node:10`](https://hub.docker.com/r/dockershelf/node)|`10`|[![](https://img.shields.io/badge/-node%2F10%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/10/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:10.svg)](https://microbadger.com/images/dockershelf/node:10)|
|[`dockershelf/node:5`](https://hub.docker.com/r/dockershelf/node)|`5`|[![](https://img.shields.io/badge/-node%2F5%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/node/5/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/node:5.svg)](https://microbadger.com/images/dockershelf/node:5)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

## Building process

The Node images are built using a bash script [`node/build-image.sh`](https://github.com/LuisAlejandro/dockershelf/blob/master/node/build-image.sh), you can check it out for details.

Each node release is installed using the [nodesource scripts](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions).

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:<release>`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools and build depends to handle the nodesource script install.
4. Install Node.
5. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro), [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.me/martinezfaneyth), so that I can continue doing what I love.

> Blog [huntingbears.com.ve](http://huntingbears.com.ve) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)