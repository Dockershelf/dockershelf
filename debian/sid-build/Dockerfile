FROM luisalejandro/debian:sid-min
MAINTAINER Luis Alejandro Martínez Faneyth <luis@huntingbears.com.ve>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="debian-sid-build" \
      org.label-schema.description="A Debian Sid image for building software." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockerfiles" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockerfiles" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0"

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install \
        dpkg-dev \
        devscripts \
        build-essential \
        lsb-release