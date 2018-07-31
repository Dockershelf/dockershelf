![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/ruby.svg)](https://hub.docker.com/r/dockershelf/ruby) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

## Ruby shelf

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

|Image  |Release  |Dockerfile  |Layers  |
|-------|---------|------------|--------|
|[`1.8`](https://hub.docker.com/r/dockershelf/ruby)|`1.8`|[![](https://img.shields.io/badge/-ruby%2F1.8%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/1.8/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:1.8.svg)](https://microbadger.com/images/dockershelf/ruby:1.8)|
|[`1.9.1`](https://hub.docker.com/r/dockershelf/ruby)|`1.9.1`|[![](https://img.shields.io/badge/-ruby%2F1.9.1%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/1.9.1/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:1.9.1.svg)](https://microbadger.com/images/dockershelf/ruby:1.9.1)|
|[`2.1`](https://hub.docker.com/r/dockershelf/ruby)|`2.1`|[![](https://img.shields.io/badge/-ruby%2F2.1%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/2.1/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:2.1.svg)](https://microbadger.com/images/dockershelf/ruby:2.1)|
|[`2.3`](https://hub.docker.com/r/dockershelf/ruby)|`2.3`|[![](https://img.shields.io/badge/-ruby%2F2.3%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/2.3/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:2.3.svg)](https://microbadger.com/images/dockershelf/ruby:2.3)|
|[`2.5`](https://hub.docker.com/r/dockershelf/ruby)|`2.5`|[![](https://img.shields.io/badge/-ruby%2F2.5%2FDockerfile-blue.svg)](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/2.5/Dockerfile)|[![](https://images.microbadger.com/badges/image/dockershelf/ruby:2.5.svg)](https://microbadger.com/images/dockershelf/ruby:2.5)|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/images/table.svg)

## Building process

The Ruby images are built using a bash script [`ruby/build-image.sh`](https://github.com/LuisAlejandro/dockershelf/blob/master/ruby/build-image.sh), you can check it out for details.

Each ruby release is downloaded and installed from the debian official repositories. Some releases are not compiled against Debian Sid libraries, so some potentially old libraries could be installed in the process.

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:sid`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the package installation.
4. Install Ruby.
5. Uninstall developer tools and orphan packages.
6. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro), [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.me/martinezfaneyth), so that I can continue doing what I love.

> Blog [luisalejandro.org](http://luisalejandro.org) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)