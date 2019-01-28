![](https://cdn.rawgit.com/LuisAlejandro/dockershelf/master/images/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/odoo.svg)](https://hub.docker.com/r/dockershelf/odoo) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

## Odoo shelf

|Image  |Release  |Dockerfile  |Layers  |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/odoo:10.0`](https://hub.docker.com/r/dockershelf/odoo)|`10.0`|[![](https://img.shields.io/badge/-odoo%2F10.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/LuisAlejandro/dockershelf/blob/master/odoo/10.0/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/odoo/10.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/odoo:10.0)|[![](https://img.shields.io/microbadger/image-size/dockershelf/odoo/10.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/odoo:10.0)|
|[`dockershelf/odoo:11.0`](https://hub.docker.com/r/dockershelf/odoo)|`11.0`|[![](https://img.shields.io/badge/-odoo%2F11.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/LuisAlejandro/dockershelf/blob/master/odoo/11.0/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/odoo/11.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/odoo:11.0)|[![](https://img.shields.io/microbadger/image-size/dockershelf/odoo/11.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/odoo:11.0)|
|[`dockershelf/odoo:12.0`](https://hub.docker.com/r/dockershelf/odoo)|`12.0`|[![](https://img.shields.io/badge/-odoo%2F12.0%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&maxAge=86400&logo=docker)](https://github.com/LuisAlejandro/dockershelf/blob/master/odoo/12.0/Dockerfile)|[![](https://img.shields.io/microbadger/layers/dockershelf/odoo/12.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/odoo:12.0)|[![](https://img.shields.io/microbadger/image-size/dockershelf/odoo/12.0.svg?colorA=22313f&colorB=4a637b&maxAge=86400)](https://microbadger.com/images/dockershelf/odoo:12.0)|

![](https://cdn.rawgit.com/LuisAlejandro/dockershelf/master/images/table.svg)

## Building process

The Python images are built using a bash script [`odoo/build-image.sh`](https://github.com/LuisAlejandro/dockershelf/blob/master/odoo/build-image.sh), you can check it out for details.

Each node release is installed using the [Odoo official installation guide](https://www.odoo.com/documentation/11.0/setup/install.html).

We'll explain the overall process here:

1. Built `FROM dockershelf/python:3.5`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the package installation.
4. Install Odoo.
5. Uninstall developer tools and orphan packages.
6. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro), [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.me/martinezfaneyth), so that I can continue doing what I love.

> Blog [luisalejandro.org](http://luisalejandro.org) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)