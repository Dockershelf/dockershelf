![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/python.svg)](https://hub.docker.com/r/dockershelf/python) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

## Python shelf

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

|Image                                    |Release  |Dockerfile                |Layers                    |
|-----------------------------------------|---------|--------------------------|--------------------------|
|[`3.6`](https://hub.docker.com/r/dockershelf/python)|`3.6`|[![](https://img.shields.io/badge/-python%2F3.6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.6.svg)](https://microbadger.com/images/dockershelf/python:3.6)|
|[`3.7`](https://hub.docker.com/r/dockershelf/python)|`3.7`|[![](https://img.shields.io/badge/-python%2F3.7%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.7/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.7.svg)](https://microbadger.com/images/dockershelf/python:3.7)|
|[`3.4`](https://hub.docker.com/r/dockershelf/python)|`3.4`|[![](https://img.shields.io/badge/-python%2F3.4%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.4/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.4.svg)](https://microbadger.com/images/dockershelf/python:3.4)|
|[`3.5`](https://hub.docker.com/r/dockershelf/python)|`3.5`|[![](https://img.shields.io/badge/-python%2F3.5%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.5/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.5.svg)](https://microbadger.com/images/dockershelf/python:3.5)|
|[`3.2`](https://hub.docker.com/r/dockershelf/python)|`3.2`|[![](https://img.shields.io/badge/-python%2F3.2%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.2/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:3.2.svg)](https://microbadger.com/images/dockershelf/python:3.2)|
|[`2.7`](https://hub.docker.com/r/dockershelf/python)|`2.7`|[![](https://img.shields.io/badge/-python%2F2.7%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/2.7/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:2.7.svg)](https://microbadger.com/images/dockershelf/python:2.7)|
|[`2.6`](https://hub.docker.com/r/dockershelf/python)|`2.6`|[![](https://img.shields.io/badge/-python%2F2.6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/python/2.6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/python:2.6.svg)](https://microbadger.com/images/dockershelf/python:2.6)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

## Building process

The Python images are built using a bash script [`python/build-image.sh`](https://github.com/LuisAlejandro/dockershelf/blob/master/python/build-image.sh), you can check it out for details.

Each python release is installed using [Pythonz](http://saghul.github.io/pythonz/).

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:<release>`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools and build depends to handle the Pythonz install and Python compilation.
4. Install Pythonz.
5. Install Python according to version.
6. Removing unnecessary packages.
7. Install `pip`.
8. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro), [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.me/martinezfaneyth), so that I can continue doing what I love.

> Blog [huntingbears.com.ve](http://huntingbears.com.ve) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)