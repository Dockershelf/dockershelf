FROM luisalejandro/debian:sid-min
MAINTAINER Luis Alejandro Martínez Faneyth <luis@huntingbears.com.ve>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL ve.com.huntingbears.build-date=${BUILD_DATE} \
      ve.com.huntingbears.name="debian-sid-build" \
      ve.com.huntingbears.description="A Debian Sid image for building software." \
      ve.com.huntingbears.url="https://github.com/LuisAlejandro/dockerfiles" \
      ve.com.huntingbears.vcs-ref=${VCS_REF} \
      ve.com.huntingbears.vcs-url="https://github.com/LuisAlejandro/dockerfiles" \
      ve.com.huntingbears.vendor="Luis Alejandro Martínez Faneyth" \
      ve.com.huntingbears.version=${VERSION} \
      ve.com.huntingbears.schema-version="1.0"

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install \
        dpkg-dev \
        devscripts \
        build-essential \
        lsb-release \
        debootstrap \
        fakeroot \
        fakechroot