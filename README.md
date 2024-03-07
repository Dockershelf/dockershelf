![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/github/actions/workflow/status/Dockershelf/dockershelf/schedule-master.yml)](https://github.com/Dockershelf/dockershelf/actions/workflows/schedule-master.yml) [![](https://img.shields.io/discord/809504357359157288.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/4Wc7xphH5e) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

Current version: 3.3.0

*Dockershelf* is a repository that serves as a collector for docker recipes that are universal, efficient and slim. We keep adding "shelves", which are holders for the different versions of a popular language or application. Images are updated, tested and published *weekly* via a [Github Actions workflow](https://github.com/Dockershelf/dockershelf/actions). All images are available on [Docker Hub](https://hub.docker.com/u/dockershelf).

Excepting debian and latex images, all images have an stable/unstable version. Stable images are based on debian stable, which are ideal for production applications because packages are not updated to minor or major versions but still recieve security updates. Unstable images are based on debian sid, which are designed for development stages because packages are constantly beaing updated to its latest version. Latex images are only based on debian stable.

Images are built for `amd64` and `arm64` architectures, which cover most of the devices in the market. If you need an image for a different architecture, please [open an issue](https://github.com/Dockershelf/dockershelf/issues/new).

The list of available images is shown below.

|Image type  |Tags  |
|------------|------|
|[dockershelf/debian](#debian)|`bullseye`, `oldstable`, `bookworm`, `stable`, `trixie`, `testing`, `sid`, `unstable`, `latest`|
|[dockershelf/python](#python)|`3.7-bookworm`, `3.7-stable`, `3.7-sid`, `3.7-unstable`, `3.7`, `3.10-bookworm`, `3.10-stable`, `3.10-sid`, `3.10-unstable`, `3.10`, `3.11-bookworm`, `3.11-stable`, `3.11-sid`, `3.11-unstable`, `3.11`, `3.12-bookworm`, `3.12-stable`, `3-stable`, `3-bookworm`, `latest-stable`, `latest-bookworm`, `3.12-sid`, `3.12-unstable`, `3.12`, `3-unstable`, `3-sid`, `3`, `latest-unstable`, `latest-sid`, `latest`|
|[dockershelf/node](#node)|`12-bookworm`, `12-stable`, `12-sid`, `12-unstable`, `12`, `14-bookworm`, `14-stable`, `14-sid`, `14-unstable`, `14`, `16-bookworm`, `16-stable`, `16-sid`, `16-unstable`, `16`, `18-bookworm`, `18-stable`, `18-sid`, `18-unstable`, `18`, `20-bookworm`, `20-stable`, `latest-stable`, `latest-bookworm`, `20-sid`, `20-unstable`, `20`, `latest-unstable`, `latest-sid`, `latest`|
|[dockershelf/go](#go)|`1.19-bookworm`, `1.19-stable`, `1.19-sid`, `1.19-unstable`, `1.19`, `1.20-bookworm`, `1.20-stable`, `1.20-sid`, `1.20-unstable`, `1.20`, `1.21-bookworm`, `1.21-stable`, `1.21-sid`, `1.21-unstable`, `1.21`, `1.22-bookworm`, `1.22-stable`, `latest-stable`, `latest-bookworm`, `1.22-sid`, `1.22-unstable`, `1.22`, `latest-unstable`, `latest-sid`, `latest`|
|[dockershelf/latex](#latex)|`basic`, `latest`, `full`|

## How to use

You can pull one of the images from Docker Hub and run it in your machine.

```
docker pull <image>
docker run -it <image> bash
```

<sup><code>&lt;image&gt;</code> is the desired image to download, for example <code>dockershelf/python:3.11</code>.</sup>

or you can use it as a base image in your Dockerfile.

```dockerfile
FROM dockershelf/debian:bookworm
RUN apt-get update \
    && apt-get install -y mysql-client
ENTRYPOINT ["mysql"]
```

## How to build locally

Clone this repository to your machine.

```
git clone https://github.com/Dockershelf/dockershelf
```

Run the build script in the root folder of your local copy. Remember to have docker installed and make sure your user has proper privileges to execute `docker build`.

```
bash build-image.sh <image>
```

<sup><code>&lt;image&gt;</code> is the desired image to build, for example <code>dockershelf/node:16-bookworm</code>.</sup>

## Shelves

### Debian

These images are similar to the official ones, but with some opinionated configurations. Check out [debian/README.md](https://github.com/Dockershelf/dockershelf/blob/master/debian/README.md) for more details.

|Image  |Dockerfile  |Pulls   |Size  |
|-------|------------|--------|------|
|[`dockershelf/debian:bullseye`](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/bullseye/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/bullseye.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:bookworm`](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:trixie`](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/trixie/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/trixie.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:sid`](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

### Python

These are debian stable/unstable images with python versions installed from the [deadsnakes ppa](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa). Check out [python/README.md](https://github.com/Dockershelf/dockershelf/blob/master/python/README.md) for more details.

|Image  |Dockerfile  |Pulls   |Size  |
|-------|------------|--------|------|
|[`dockershelf/python:3.7-bookworm`](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.7-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.7-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.7-sid`](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.7-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.7-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.10-bookworm`](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.10-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.10-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.10-sid`](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.10-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.10-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.11-bookworm`](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.11-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.11-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.11-sid`](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.11-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.11-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.12-bookworm`](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.12-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.12-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|
|[`dockershelf/python:3.12-sid`](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/python/3.12-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/python?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|[![](https://img.shields.io/docker/image-size/dockershelf/python/3.12-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/python)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

### Node

These are debian stable/unstable images with node versions built using the [nodesource installation script](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions). Check out [node/README.md](https://github.com/Dockershelf/dockershelf/blob/master/node/README.md) for more details.

|Image  |Dockerfile  |Pulls   |Size  |
|-------|------------|--------|------|
|[`dockershelf/node:12-bookworm`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/12-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/12-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:12-sid`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/12-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/12-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:14-bookworm`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/14-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/14-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:14-sid`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/14-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/14-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:16-bookworm`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/16-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/16-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:16-sid`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/16-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/16-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:18-bookworm`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/18-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/18-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:18-sid`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/18-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/18-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:20-bookworm`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/20-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/20-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|
|[`dockershelf/node:20-sid`](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/node/20-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/node?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|[![](https://img.shields.io/docker/image-size/dockershelf/node/20-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/node)|

### Go

These are debian stable/unstable images with go version downloaded directly from the [official website](https://go.dev/dl/). Check out [node/README.md](https://github.com/Dockershelf/dockershelf/blob/master/go/README.md) for more details.

|Image  |Dockerfile  |Pulls   |Size  |
|-------|------------|--------|------|
|[`dockershelf/go:1.19-bookworm`](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/go/1.19-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/go?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/docker/image-size/dockershelf/go/1.19-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|
|[`dockershelf/go:1.19-sid`](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/go/1.19-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/go?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/docker/image-size/dockershelf/go/1.19-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|
|[`dockershelf/go:1.20-bookworm`](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/go/1.20-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/go?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/docker/image-size/dockershelf/go/1.20-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|
|[`dockershelf/go:1.20-sid`](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/go/1.20-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/go?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/docker/image-size/dockershelf/go/1.20-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|
|[`dockershelf/go:1.21-bookworm`](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/go/1.21-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/go?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/docker/image-size/dockershelf/go/1.21-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|
|[`dockershelf/go:1.21-sid`](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/go/1.21-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/go?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/docker/image-size/dockershelf/go/1.21-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|
|[`dockershelf/go:1.22-bookworm`](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/go/1.22-bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/go?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/docker/image-size/dockershelf/go/1.22-bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|
|[`dockershelf/go:1.22-sid`](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/go/1.22-sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/go?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|[![](https://img.shields.io/docker/image-size/dockershelf/go/1.22-sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/go)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

### Latex

These are debian stable images that come with a set of latex (basic or full) packages installed. Check out [latex/README.md](https://github.com/Dockershelf/dockershelf/blob/master/latex/README.md) for more details.

|Image  |Dockerfile  |Pulls   |Size  |
|-------|------------|--------|------|
|[`dockershelf/latex:basic`](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/basic/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/basic.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/latex)|
|[`dockershelf/latex:full`](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/latex/full/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/latex?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/latex)|[![](https://img.shields.io/docker/image-size/dockershelf/latex/full.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/latex)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

## Made with 💖 and 🍔

![Banner](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/author-banner.svg)

> Web [luisalejandro.org](http://luisalejandro.org/) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)