FROM scratch
MAINTAINER Luis Alejandro Martínez Faneyth <luis@huntingbears.com.ve>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL ve.com.huntingbears.build-date=${BUILD_DATE} \
      ve.com.huntingbears.name="debian-jessie" \
      ve.com.huntingbears.description="A Debian Jessie minimal image built from scratch." \
      ve.com.huntingbears.url="https://github.com/LuisAlejandro/dockershelf" \
      ve.com.huntingbears.vcs-ref=${VCS_REF} \
      ve.com.huntingbears.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      ve.com.huntingbears.vendor="Luis Alejandro Martínez Faneyth" \
      ve.com.huntingbears.version=${VERSION} \
      ve.com.huntingbears.schema-version="1.0"

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="jessie"

ADD base /