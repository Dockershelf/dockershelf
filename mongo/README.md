![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/mongo.svg)](https://hub.docker.com/r/dockershelf/mongo) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

## Node shelf

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

|Image                                    |Release  |Dockerfile                |Layers                    |
|-----------------------------------------|---------|--------------------------|--------------------------|
|[`dockershelf/mongo:3.0`](https://hub.docker.com/r/dockershelf/mongo)|`3.0`|[![](https://img.shields.io/badge/-mongo%2F3.0%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/3.0/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/mongo:3.0.svg)](https://microbadger.com/images/dockershelf/mongo:3.0)|
|[`dockershelf/mongo:3.2`](https://hub.docker.com/r/dockershelf/mongo)|`3.2`|[![](https://img.shields.io/badge/-mongo%2F3.2%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/3.2/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/mongo:3.2.svg)](https://microbadger.com/images/dockershelf/mongo:3.2)|
|[`dockershelf/mongo:3.4`](https://hub.docker.com/r/dockershelf/mongo)|`3.4`|[![](https://img.shields.io/badge/-mongo%2F3.4%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/3.4/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/mongo:3.4.svg)](https://microbadger.com/images/dockershelf/mongo:3.4)|
|[`dockershelf/mongo:3.6`](https://hub.docker.com/r/dockershelf/mongo)|`3.6`|[![](https://img.shields.io/badge/-mongo%2F3.6%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/3.6/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/mongo:3.6.svg)](https://microbadger.com/images/dockershelf/mongo:3.6)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

## Building process

The Mongo images are built using a bash script [`mongo/build-image.sh`](https://github.com/LuisAlejandro/dockershelf/blob/master/mongo/build-image.sh), you can check it out for details.

Each mongo release is installed using the [official installation guide](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/).

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