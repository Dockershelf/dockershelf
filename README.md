![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/github/workflow/status/Dockershelf/dockershelf/Schedule%20(master%20branch))](https://github.com/Dockershelf/dockershelf/actions/workflows/schedule-master.yml) [![](https://img.shields.io/discord/809504357359157288)](https://discord.gg/4Wc7xphH5e) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

Current version: 3.2.0

*Dockershelf* is a repository that serves as a collector for docker recipes that are universal, efficient and slim. We keep adding "shelves", which are holders for the different versions of a popular language or application.

Images are updated, tested and published *weekly* via a [Github Actions workflow](https://github.com/Dockershelf/dockershelf/actions).

## About stable/unstable images

Excepting debian and latex images, all images have an stable/unstable version. Stable images are based on debian stable, which are ideal for production applications; Unstable images are based on debian sid, which are designed for development stages.

## How to use

Pull one of the available images and start hacking!

```bash
docker pull <image>
docker run -it <image> bash
```
<sup>&lt;image&gt; is the desired image to download, for example <code>dockershelf/python:2.7</code>.</sup>

## How to build locally

Clone this repository to your machine.

```bash
git clone https://github.com/Dockershelf/dockershelf
```

Run the build script in the root folder of your local copy. Remember to have docker installed and make sure your user has proper privileges to execute `docker build`.

```bash
bash build-image.sh <image>
```

<sup>&lt;image&gt; is the desired image to build, for example <code>dockershelf/debian:sid</code>.</sup>

## Shelves

### Debian

These images are similar to the official ones, but with some opinionated configurations. Check out [debian/README.md](https://github.com/Dockershelf/dockershelf/blob/master/debian/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/debian:bullseye`](https://hub.docker.com/r/dockershelf/debian)|`bullseye`|[![](https://img.shields.io/badge/-debian%2Fbullseye%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/bullseye/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/bullseye.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:bookworm`](https://hub.docker.com/r/dockershelf/debian)|`bookworm`|[![](https://img.shields.io/badge/-debian%2Fbookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:trixie`](https://hub.docker.com/r/dockershelf/debian)|`trixie`|[![](https://img.shields.io/badge/-debian%2Ftrixie%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/trixie/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/trixie.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:sid`](https://hub.docker.com/r/dockershelf/debian)|`sid`|[![](https://img.shields.io/badge/-debian%2Fsid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/debian)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

### Latex

These are debian unstable images that come with a set of latex (basic or full) packages installed. Check out [latex/README.md](https://github.com/Dockershelf/dockershelf/blob/master/latex/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/latex:basic`](https://hub.docker.com/r/dockershelf/latex)|`basic`|[![](https://img.shields.io/badge/-latex%2Fbasic%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/basic/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/basic.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|
|[`dockershelf/latex:full`](https://hub.docker.com/r/dockershelf/latex)|`full`|[![](https://img.shields.io/badge/-latex%2Ffull%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/full/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/full.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/latex)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

### Python

These are debian stable/unstable images with python versions installed from the [deadsnakes ppa](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa). Check out [python/README.md](https://github.com/Dockershelf/dockershelf/blob/master/python/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/python:3.7-bookworm`](https://hub.docker.com/r/dockershelf/python)|`3.7-bookworm`|[![](https://img.shields.io/badge/-python%2F3.7--bookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.7-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.7-bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.7-sid`](https://hub.docker.com/r/dockershelf/python)|`3.7-sid`|[![](https://img.shields.io/badge/-python%2F3.7--sid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.7-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.7-sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.10-bookworm`](https://hub.docker.com/r/dockershelf/python)|`3.10-bookworm`|[![](https://img.shields.io/badge/-python%2F3.10--bookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.10-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.10-bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.10-sid`](https://hub.docker.com/r/dockershelf/python)|`3.10-sid`|[![](https://img.shields.io/badge/-python%2F3.10--sid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.10-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.10-sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.11-bookworm`](https://hub.docker.com/r/dockershelf/python)|`3.11-bookworm`|[![](https://img.shields.io/badge/-python%2F3.11--bookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.11-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.11-bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.11-sid`](https://hub.docker.com/r/dockershelf/python)|`3.11-sid`|[![](https://img.shields.io/badge/-python%2F3.11--sid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.11-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.11-sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.12-bookworm`](https://hub.docker.com/r/dockershelf/python)|`3.12-bookworm`|[![](https://img.shields.io/badge/-python%2F3.12--bookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.12-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.12-bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.12-sid`](https://hub.docker.com/r/dockershelf/python)|`3.12-sid`|[![](https://img.shields.io/badge/-python%2F3.12--sid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.12-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.12-sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/python)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

### Node

These are debian stable/unstable images with node versions built using the [nodesource installation script](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions). Check out [node/README.md](https://github.com/Dockershelf/dockershelf/blob/master/node/README.md) for more details.

|Image  |Release  |Dockerfile  |Pulls   |Size  |
|-------|---------|------------|--------|------|
|[`dockershelf/node:12-bookworm`](https://hub.docker.com/r/dockershelf/node)|`12-bookworm`|[![](https://img.shields.io/badge/-node%2F12--bookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/12-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/12-bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:12-sid`](https://hub.docker.com/r/dockershelf/node)|`12-sid`|[![](https://img.shields.io/badge/-node%2F12--sid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/12-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/12-sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:14-bookworm`](https://hub.docker.com/r/dockershelf/node)|`14-bookworm`|[![](https://img.shields.io/badge/-node%2F14--bookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/14-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/14-bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:14-sid`](https://hub.docker.com/r/dockershelf/node)|`14-sid`|[![](https://img.shields.io/badge/-node%2F14--sid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/14-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/14-sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:16-bookworm`](https://hub.docker.com/r/dockershelf/node)|`16-bookworm`|[![](https://img.shields.io/badge/-node%2F16--bookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/16-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/16-bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:16-sid`](https://hub.docker.com/r/dockershelf/node)|`16-sid`|[![](https://img.shields.io/badge/-node%2F16--sid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/16-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/16-sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:18-bookworm`](https://hub.docker.com/r/dockershelf/node)|`18-bookworm`|[![](https://img.shields.io/badge/-node%2F18--bookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/18-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/18-bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:18-sid`](https://hub.docker.com/r/dockershelf/node)|`18-sid`|[![](https://img.shields.io/badge/-node%2F18--sid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/18-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/18-sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:20-bookworm`](https://hub.docker.com/r/dockershelf/node)|`20-bookworm`|[![](https://img.shields.io/badge/-node%2F20--bookworm%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/20-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/20-bookworm.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:20-sid`](https://hub.docker.com/r/dockershelf/node)|`20-sid`|[![](https://img.shields.io/badge/-node%2F20--sid%2FDockerfile-blue.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/20-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/20-sid.svg?colorA=22313f&colorB=4a637b&cacheSeconds=900)](https://hub.docker.com/r/dockershelf/node)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

## Made with 💖 and 🍔

![Banner](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/author-banner.svg)

> Web [luisalejandro.org](http://luisalejandro.org/) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)