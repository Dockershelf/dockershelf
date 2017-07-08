![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/banner.svg)

---

[![](https://img.shields.io/github/release/LuisAlejandro/dockershelf.svg)](https://github.com/LuisAlejandro/dockershelf/releases) [![](https://img.shields.io/travis/LuisAlejandro/dockershelf.svg)](https://travis-ci.org/LuisAlejandro/dockershelf) [![](https://img.shields.io/github/issues-raw/LuisAlejandro/dockershelf/in%20progress.svg?label=in%20progress)](https://github.com/LuisAlejandro/dockershelf/issues?q=is%3Aissue+is%3Aopen+label%3A%22in+progress%22) [![](https://badges.gitter.im/LuisAlejandro/dockershelf.svg)](https://gitter.im/LuisAlejandro/dockershelf) [![](https://cla-assistant.io/readme/badge/LuisAlejandro/dockershelf)](https://cla-assistant.io/LuisAlejandro/dockershelf)

Current version: 0.1.5

*Dockershelf* is a repository that serves as a collector for docker recipes that I've found useful for specific cases and personal applications. However, I've designed them for universal purposes, so that they can serve for other applications as well.

All docker images are updated, tested and published *daily* via a Travis cron job.

## Shelves

### Debian

These images are similar to the official ones, but with some improved configurations. Check out [debian/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/debian/README.md) for more details.

[iwheezyl]: https://hub.docker.com/r/dockershelf/debian
[dwheezy]: https://img.shields.io/badge/-debian%2Fwheezy%2FDockerfile-blue.svg
[dwheezyl]: https://github.com/LuisAlejandro/dockershelf/blob/master/debian/wheezy/Dockerfile
[lwheezy]: https://images.microbadger.com/badges/image/dockershelf/debian:wheezy.svg
[lwheezyl]: https://microbadger.com/images/dockershelf/debian:wheezy

[ijessiel]: https://hub.docker.com/r/dockershelf/debian
[djessie]: https://img.shields.io/badge/-debian%2Fjessie%2FDockerfile-blue.svg
[djessiel]: https://github.com/LuisAlejandro/dockershelf/blob/master/debian/jessie/Dockerfile
[ljessie]: https://images.microbadger.com/badges/image/dockershelf/debian:jessie.svg
[ljessiel]: https://microbadger.com/images/dockershelf/debian:jessie

[istretchl]: https://hub.docker.com/r/dockershelf/debian
[dstretch]: https://img.shields.io/badge/-debian%2Fstretch%2FDockerfile-blue.svg
[dstretchl]: https://github.com/LuisAlejandro/dockershelf/blob/master/debian/stretch/Dockerfile
[lstretch]: https://images.microbadger.com/badges/image/dockershelf/debian:stretch.svg
[lstretchl]: https://microbadger.com/images/dockershelf/debian:stretch

[isidl]: https://hub.docker.com/r/dockershelf/debian
[dsid]: https://img.shields.io/badge/-debian%2Fsid%2FDockerfile-blue.svg
[dsidl]: https://github.com/LuisAlejandro/dockershelf/blob/master/debian/sid/Dockerfile
[lsid]: https://images.microbadger.com/badges/image/dockershelf/debian:sid.svg
[lsidl]: https://microbadger.com/images/dockershelf/debian:sid

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

|Image                                    |Release  |Dockerfile                |Layers                    |
|-----------------------------------------|---------|--------------------------|--------------------------|
|[`dockershelf/debian:wheezy`][iwheezyl]  |`wheezy` |[![][dwheezy]][dwheezyl]  |[![][lwheezy]][lwheezyl]  |
|[`dockershelf/debian:jessie`][ijessiel]  |`jessie` |[![][djessie]][djessiel]  |[![][ljessie]][ljessiel]  |
|[`dockershelf/debian:stretch`][istretchl]|`stretch`|[![][dstretch]][dstretchl]|[![][lstretch]][lstretchl]|
|[`dockershelf/debian:sid`][isidl]        |`sid`    |[![][dsid]][dsidl]        |[![][lsid]][lsidl]        |

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

### Python

These are python images compiled from source, using the `debian/rules` makefile from debian's python source. These images are then updated to Debian Sid. Check out [python/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/python/README.md) for more details.

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

[i2.7-3.5l]: https://hub.docker.com/r/dockershelf/python
[d2.7-3.5]: https://img.shields.io/badge/-python%2F2.7--3.6%2FDockerfile-blue.svg
[d2.7-3.5l]: https://github.com/LuisAlejandro/dockershelf/blob/master/python/2.7-3.5/Dockerfile
[l2.7-3.5]: https://images.microbadger.com/badges/image/dockershelf/python:2.7-3.5.svg
[l2.7-3.5l]: https://microbadger.com/images/dockershelf/python:2.7-3.5

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

|Image                                    |Release  |Dockerfile                |Layers                    |
|-----------------------------------------|---------|--------------------------|--------------------------|
|[`dockershelf/python:2.6`][i2.6l]        |`2.6`    |[![][d2.6]][d2.6l]        |[![][l2.6]][l2.6l]        |
|[`dockershelf/python:2.7`][i2.7l]        |`2.7`    |[![][d2.7]][d2.7l]        |[![][l2.7]][l2.7l]        |
|[`dockershelf/python:3.2`][i3.2l]        |`3.2`    |[![][d3.2]][d3.2l]        |[![][l3.2]][l3.2l]        |
|[`dockershelf/python:3.4`][i3.4l]        |`3.4`    |[![][d3.4]][d3.4l]        |[![][l3.4]][l3.4l]        |
|[`dockershelf/python:3.5`][i3.5l]        |`3.5`    |[![][d3.5]][d3.5l]        |[![][l3.5]][l3.5l]        |
|[`dockershelf/python:3.6`][i3.6l]        |`3.6`    |[![][d3.6]][d3.6l]        |[![][l3.6]][l3.6l]        |
|[`dockershelf/python:2.7-3.5`][i2.7-3.5l]|`2.7-3.5`|[![][d2.7-3.5]][d2.7-3.5l]|[![][l2.7-3.5]][l2.7-3.5l]|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

### PyPIContents

These are images based on `dockershelf/python` images and are used to build the [PyPIContents Index](https://github.com/LuisAlejandro/pypicontents). Check out [pypicontents/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/pypicontents/README.md) for more details.

[ipypi2.6l]: https://hub.docker.com/r/dockershelf/pypicontents
[dpypi2.6]: https://img.shields.io/badge/-pypicontents%2F2.6%2FDockerfile-blue.svg
[dpypi2.6l]: https://github.com/LuisAlejandro/dockershelf/blob/master/pypicontents/2.6/Dockerfile
[lpypi2.6]: https://images.microbadger.com/badges/image/dockershelf/pypicontents:2.6.svg
[lpypi2.6l]: https://microbadger.com/images/dockershelf/pypicontents:2.6

[ipypi2.7l]: https://hub.docker.com/r/dockershelf/pypicontents
[dpypi2.7]: https://img.shields.io/badge/-pypicontents%2F2.7%2FDockerfile-blue.svg
[dpypi2.7l]: https://github.com/LuisAlejandro/dockershelf/blob/master/pypicontents/2.7/Dockerfile
[lpypi2.7]: https://images.microbadger.com/badges/image/dockershelf/pypicontents:2.7.svg
[lpypi2.7l]: https://microbadger.com/images/dockershelf/pypicontents:2.7

[ipypi3.2l]: https://hub.docker.com/r/dockershelf/pypicontents
[dpypi3.2]: https://img.shields.io/badge/-pypicontents%2F3.2%2FDockerfile-blue.svg
[dpypi3.2l]: https://github.com/LuisAlejandro/dockershelf/blob/master/pypicontents/3.2/Dockerfile
[lpypi3.2]: https://images.microbadger.com/badges/image/dockershelf/pypicontents:3.2.svg
[lpypi3.2l]: https://microbadger.com/images/dockershelf/pypicontents:3.2

[ipypi3.4l]: https://hub.docker.com/r/dockershelf/pypicontents
[dpypi3.4]: https://img.shields.io/badge/-pypicontents%2F3.4%2FDockerfile-blue.svg
[dpypi3.4l]: https://github.com/LuisAlejandro/dockershelf/blob/master/pypicontents/3.4/Dockerfile
[lpypi3.4]: https://images.microbadger.com/badges/image/dockershelf/pypicontents:3.4.svg
[lpypi3.4l]: https://microbadger.com/images/dockershelf/pypicontents:3.4

[ipypi3.5l]: https://hub.docker.com/r/dockershelf/pypicontents
[dpypi3.5]: https://img.shields.io/badge/-pypicontents%2F3.5%2FDockerfile-blue.svg
[dpypi3.5l]: https://github.com/LuisAlejandro/dockershelf/blob/master/pypicontents/3.5/Dockerfile
[lpypi3.5]: https://images.microbadger.com/badges/image/dockershelf/pypicontents:3.5.svg
[lpypi3.5l]: https://microbadger.com/images/dockershelf/pypicontents:3.5

[ipypi3.6l]: https://hub.docker.com/r/dockershelf/pypicontents
[dpypi3.6]: https://img.shields.io/badge/-pypicontents%2F3.6%2FDockerfile-blue.svg
[dpypi3.6l]: https://github.com/LuisAlejandro/dockershelf/blob/master/pypicontents/3.6/Dockerfile
[lpypi3.6]: https://images.microbadger.com/badges/image/dockershelf/pypicontents:3.6.svg
[lpypi3.6l]: https://microbadger.com/images/dockershelf/pypicontents:3.6

[ipypi2.7-3.5l]: https://hub.docker.com/r/dockershelf/pypicontents
[dpypi2.7-3.5]: https://img.shields.io/badge/-pypicontents%2F2.7--3.6%2FDockerfile-blue.svg
[dpypi2.7-3.5l]: https://github.com/LuisAlejandro/dockershelf/blob/master/pypicontents/2.7-3.5/Dockerfile
[lpypi2.7-3.5]: https://images.microbadger.com/badges/image/dockershelf/pypicontents:2.7-3.5.svg
[lpypi2.7-3.5l]: https://microbadger.com/images/dockershelf/pypicontents:2.7-3.5

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

|Image                                              |Release  |Dockerfile                        |Layers                            |
|---------------------------------------------------|---------|----------------------------------|----------------------------------|
|[`dockershelf/pypicontents:2.6`][ipypi2.6l]        |`2.6`    |[![][dpypi2.6]][dpypi2.6l]        |[![][lpypi2.6]][lpypi2.6l]        |
|[`dockershelf/pypicontents:2.7`][ipypi2.7l]        |`2.7`    |[![][dpypi2.7]][dpypi2.7l]        |[![][lpypi2.7]][lpypi2.7l]        |
|[`dockershelf/pypicontents:3.2`][ipypi3.2l]        |`3.2`    |[![][dpypi3.2]][dpypi3.2l]        |[![][lpypi3.2]][lpypi3.2l]        |
|[`dockershelf/pypicontents:3.4`][ipypi3.4l]        |`3.4`    |[![][dpypi3.4]][dpypi3.4l]        |[![][lpypi3.4]][lpypi3.4l]        |
|[`dockershelf/pypicontents:3.5`][ipypi3.5l]        |`3.5`    |[![][dpypi3.5]][dpypi3.5l]        |[![][lpypi3.5]][lpypi3.5l]        |
|[`dockershelf/pypicontents:3.6`][ipypi3.6l]        |`3.6`    |[![][dpypi3.6]][dpypi3.6l]        |[![][lpypi3.6]][lpypi3.6l]        |
|[`dockershelf/pypicontents:2.7-3.5`][ipypi2.7-3.5l]|`2.7-3.5`|[![][dpypi2.7-3.5]][dpypi2.7-3.5l]|[![][lpypi2.7-3.5]][lpypi2.7-3.5l]|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

### Latex

This is an image based on [`dockershelf/debian:sid`](https://microbadger.com/images/dockershelf/debian:sid) with `texlive-fonts-recommended`, `texlive-latex-base`, `texlive-latex-extra` and `latex-xcolor` packages installed. It should be enough to use the `pdflatex` binary for basic Latex to PDF conversion. Check out [latex/README.md](https://github.com/LuisAlejandro/dockershelf/blob/master/latex/README.md) for more details.

[ilatexl]: https://hub.docker.com/r/dockershelf/latex
[dlatex]: https://img.shields.io/badge/-latex%2Fsid%2FDockerfile-blue.svg
[dlatexl]: https://github.com/LuisAlejandro/dockershelf/blob/master/latex/sid/Dockerfile
[llatex]: https://images.microbadger.com/badges/image/dockershelf/latex:sid.svg
[llatexl]: https://microbadger.com/images/dockershelf/latex:sid

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

|Image                             |Release|Dockerfile            |Layers                |
|----------------------------------|-------|----------------------|----------------------|
|[`dockershelf/latex:sid`][ilatexl]|`sid`  |[![][dlatex]][dlatexl]|[![][llatex]][llatexl]|

![](https://gitcdn.xyz/repo/LuisAlejandro/dockershelf/master/table.svg)

## How to download

Pull one of the available images and start hacking!

```bash
git pull [docker image name]
git run -it [docker image name] bash
```
<sup>[docker image name] is the desired image to download.</sup>

## How to build locally

Clone this repository to your machine.

```bash
git clone https://github.com/LuisAlejandro/dockershelf
```

Run the build script in the root folder of your local copy. Remember to have docker installed and make sure your user has proper privileges to execute `docker build`.

```bash
bash build-image.sh [docker image name]
```

<sup>[docker image name] is the desired image to build.</sup>

## Made with :heart: and :hamburger:

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro),  [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=B8LPXHQY8QE8Y), so that I can continue doing what I love.

> Blog [huntingbears.com.ve](http://huntingbears.com.ve) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)