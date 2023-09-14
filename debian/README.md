![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/banner.svg)

---

[![](https://img.shields.io/github/release/Dockershelf/dockershelf.svg)](https://github.com/Dockershelf/dockershelf/releases) [![](https://img.shields.io/github/actions/workflow/status/Dockershelf/dockershelf/schedule-master.yml)](https://github.com/Dockershelf/dockershelf/actions/workflows/schedule-master.yml) [![](https://img.shields.io/docker/pulls/dockershelf/debian.svg)](https://hub.docker.com/r/dockershelf/debian) [![](https://img.shields.io/discord/809504357359157288.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/4Wc7xphH5e) [![](https://cla-assistant.io/readme/badge/Dockershelf/dockershelf)](https://cla-assistant.io/Dockershelf/dockershelf)

## Debian shelf

|Image  |Dockerfile  |Pulls   |Size  |
|-------|------------|--------|------|
|[`dockershelf/debian:bullseye`](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/bullseye/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/bullseye.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:bookworm`](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/bookworm/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/bookworm.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:trixie`](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/trixie/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/trixie.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|
|[`dockershelf/debian:sid`](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/badge/-Dockerfile-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](https://github.com/Dockershelf/dockershelf/blob/master/debian/sid/Dockerfile)|[![](https://img.shields.io/docker/pulls/dockershelf/debian?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|[![](https://img.shields.io/docker/image-size/dockershelf/debian/sid.svg?colorA=22313f&colorB=4a637b)](https://hub.docker.com/r/dockershelf/debian)|

![](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/table.svg)

## Building process

You can check out the Dockerfile for each debian release at `debian/<release>/Dockerfile`.
The base filesystem is created with [`debian/build-image.sh`](https://github.com/Dockershelf/dockershelf/blob/master/debian/build-image.sh)

However, we explain the overall process here:

1. Built `FROM scratch`.
2. Labelled according to [label-schema.org](http://label-schema.org) and [opencontainers specification](https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys).
3. The base filesystem is built with `debootstrap` using the following command.

        debootstrap --verbose --variant minbase --arch amd64 --no-check-gpg --no-check-certificate --merged-usr <release> <dir>

4. Then the following files are configured:

    * `/etc/resolv.conf`: DNS servers to be used (google).

            nameserver 8.8.8.8
            nameserver 8.8.4.4

    * `/etc/locale.gen`: Locales to be configured.

            # Dockershelf configuration for locale
            en_US.UTF-8 UTF-8

    * `/etc/apt/sources.list`: Content may vary depending on release. For example, sid does not have security updates.

            # Dockershelf configuration for apt sources
            deb <mirror> <release> main
            deb <mirror> <release>-updates main
            deb <security-mirror> <release>/updates main

    * `/etc/dpkg/dpkg.cfg.d/dockershelf`: Default options to pass to `dpkg`. Options here are like passing `--<option>` but without the double hiphens. Check out the [manpage for dpkg](http://manpages.ubuntu.com/manpages/trusty/man1/dpkg.1.html) for more information.

            # Dockershelf configuration for Dpkg

            # If a conffile has been deleted by the user and a new version of the
            # package wants to install it, let it do it.
            force-confmiss

            # If a package has a new version of a conffile but the user has modified it,
            # answer the question with the default option.
            force-confdef

            # If a package has a new version of a conffile but the user has modified it,
            # and there's no default option, replace the conffile with the new one.
            force-confnew

            # If a package tries to overwrite a file that exists in another package,
            # let it do it.
            force-overwrite

            # Don't call sync() for every IO operation.
            force-unsafe-io

    * `/etc/apt/apt.conf.d/dockershelf`: Default options passed to `apt`. Check out the [manpage for apt.conf](http://manpages.ubuntu.com/manpages/zesty/man5/apt.conf.5.html) and the [apt configuration index](http://sources.debian.net/src/apt/1.0.9.8.3/doc/examples/configure-index) for more information.

            # Dockershelf configuration for Apt

            # Disable creation of pkgcache.bin and srcpkgcache.bin to save space.
            Dir::Cache::pkgcache "";
            Dir::Cache::srcpkgcache "";

            # If there's a network error, retry up to 3 times.
            Acquire::Retries "3";

            # Don't download translations.
            Acquire::Languages "none";

            # Prefer download of xzipped indexes.
            Acquire::CompressionTypes::Order:: "xz";

            # Keep indexes gzipped.
            Acquire::GzipIndexes "true";

            # Don't check for expired resources
            Acquire::Check-Valid-Until "false";

            # Don't install Suggests or Recommends.
            Apt::Install-Suggests "false";
            Apt::Install-Recommends "false";

            # Don't ask questions, assume 'yes'.
            Apt::Get::Assume-Yes "true";
            Aptitude::CmdLine::Assume-Yes "true";

            # Allow installation of unauthenticated packages.
            Apt::Get::AllowUnauthenticated "true";
            Aptitude::CmdLine::Ignore-Trust-Violations "true";

            # Remove suggested and recommended packages on autoremove.
            Apt::AutoRemove::SuggestsImportant "false";
            Apt::AutoRemove::RecommendsImportant "false";

            # Cleaning post-hooks for dpkg and apt.
            Apt::Update::Post-Invoke { "/usr/share/dockershelf/clean-apt.sh"; };
            Dpkg::Post-Invoke { "/usr/share/dockershelf/clean-dpkg.sh"; };

    * `/etc/bash.bashrc`: Configure bash-completion and colorful prompt.

5. Install `iproute2`, `inetutils-ping`, `locales`, `curl`, `ca-certificates` and `bash-completion` packages.
6. Configure locales.
7. Delete unnecessary files to shrink image.

## Made with 💖 and 🍔

![Banner](https://raw.githubusercontent.com/Dockershelf/dockershelf/develop/images/author-banner.svg)

> Web [luisalejandro.org](http://luisalejandro.org/) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)