![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/docker/pulls/dockershelf/python.svg)](https://hub.docker.com/r/dockershelf/python) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

## Python shelf

[i2.6l]: https://hub.docker.com/r/dockershelf/python
[d2.6]: https://img.shields.io/badge/-python%2F2.6%2FDockerfile-blue.svg
[d2.6l]: https://github.com/LuisAlejandro/dockershelf/blob/master/python/2.6/Dockerfile
[l2.6]: https://images.microbadger.com/badges/image/dockershelf/python:2.6.svg
[l2.6l]: https://microbadger.com/images/dockershelf/python:2.6

[i2.7l]: https://hub.docker.com/r/dockershelf/python
[d2.7]: https://img.shields.io/badge/-python%2F2.7%2FDockerfile-blue.svg
[d2.7l]: https://github.com/LuisAlejandro/dockershelf/blob/master/python/2.7/Dockerfile
[l2.7]: https://images.microbadger.com/badges/image/dockershelf/python:2.7.svg
[l2.7l]: https://microbadger.com/images/dockershelf/python:2.7

[i3.2l]: https://hub.docker.com/r/dockershelf/python
[d3.2]: https://img.shields.io/badge/-python%2F3.2%2FDockerfile-blue.svg
[d3.2l]: https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.2/Dockerfile
[l3.2]: https://images.microbadger.com/badges/image/dockershelf/python:3.2.svg
[l3.2l]: https://microbadger.com/images/dockershelf/python:3.2

[i3.4l]: https://hub.docker.com/r/dockershelf/python
[d3.4]: https://img.shields.io/badge/-python%2F3.4%2FDockerfile-blue.svg
[d3.4l]: https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.4/Dockerfile
[l3.4]: https://images.microbadger.com/badges/image/dockershelf/python:3.4.svg
[l3.4l]: https://microbadger.com/images/dockershelf/python:3.4

[i3.5l]: https://hub.docker.com/r/dockershelf/python
[d3.5]: https://img.shields.io/badge/-python%2F3.5%2FDockerfile-blue.svg
[d3.5l]: https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.5/Dockerfile
[l3.5]: https://images.microbadger.com/badges/image/dockershelf/python:3.5.svg
[l3.5l]: https://microbadger.com/images/dockershelf/python:3.5

[i3.6l]: https://hub.docker.com/r/dockershelf/python
[d3.6]: https://img.shields.io/badge/-python%2F3.6%2FDockerfile-blue.svg
[d3.6l]: https://github.com/LuisAlejandro/dockershelf/blob/master/python/3.6/Dockerfile
[l3.6]: https://images.microbadger.com/badges/image/dockershelf/python:3.6.svg
[l3.6l]: https://microbadger.com/images/dockershelf/python:3.6

[i2.7-3.6l]: https://hub.docker.com/r/dockershelf/python
[d2.7-3.6]: https://img.shields.io/badge/-python%2F2.7--3.6%2FDockerfile-blue.svg
[d2.7-3.6l]: https://github.com/LuisAlejandro/dockershelf/blob/master/python/2.7-3.6/Dockerfile
[l2.7-3.6]: https://images.microbadger.com/badges/image/dockershelf/python:2.7-3.6.svg
[l2.7-3.6l]: https://microbadger.com/images/dockershelf/python:2.7-3.6

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

|Image                                    |Release  |Dockerfile                |Layers                    |
|-----------------------------------------|---------|--------------------------|--------------------------|
|[`dockershelf/python:2.6`][i2.6l]        |`2.6`    |[![][d2.6]][d2.6l]        |[![][l2.6]][l2.6l]        |
|[`dockershelf/python:2.7`][i2.7l]        |`2.7`    |[![][d2.7]][d2.7l]        |[![][l2.7]][l2.7l]        |
|[`dockershelf/python:3.2`][i3.2l]        |`3.2`    |[![][d3.2]][d3.2l]        |[![][l3.2]][l3.2l]        |
|[`dockershelf/python:3.4`][i3.4l]        |`3.4`    |[![][d3.4]][d3.4l]        |[![][l3.4]][l3.4l]        |
|[`dockershelf/python:3.5`][i3.5l]        |`3.5`    |[![][d3.5]][d3.5l]        |[![][l3.5]][l3.5l]        |
|[`dockershelf/python:3.6`][i3.6l]        |`3.6`    |[![][d3.6]][d3.6l]        |[![][l3.6]][l3.6l]        |
|[`dockershelf/python:2.7-3.6`][i2.7-3.6l]|`2.7-3.6`|[![][d2.7-3.6]][d2.7-3.6l]|[![][l2.7-3.6]][l2.7-3.6l]|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

## Building process

The Python images are built using a bash script [`python/build-image.sh`](https://github.com/LuisAlejandro/dockershelf/blob/master/python/build-image.sh), you can check it out for details.

Each python release is downloaded from Debian sources. Due to the nature of debian packaging, some releases of Python can only be compiled on specific releases of Debian. Based on that premise, Python will be compiled against the corresponding image and then upgraded to Debian Sid.

We'll explain the overall process here:

1. Built `FROM dockershelf/debian:<release>`.
2. Labelled according to [label-schema.org](http://label-schema.org).
3. Install developer tools to handle the python source download.
4. Download Python source with `apt-get source python<release>`.
5. Parse `Build-Depends` and `Depends` fields.
6. Install `Build-Depends` and `Depends` packages.
7. Compile Python using `make -f debian/rules install`.
8. Uninstall `Build-Depends`, developer tools and orphan packages.
9. Install Python by copying the compiled files to their corresponding places.
10. Upgrade image to Debian Sid.
11. Install `pip`.
12. Shrink image by deleting unnecessary files.

## Made with :heart: and :hamburger:

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro),  [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=B8LPXHQY8QE8Y), so that I can continue doing what I love.

> Blog [huntingbears.com.ve](http://huntingbears.com.ve) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)