FROM luisalejandro/debian:sid-min
MAINTAINER Luis Alejandro Martínez Faneyth <luis@huntingbears.com.ve>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="python3.4" \
      org.label-schema.description="A Python 3.4 image based on Debian Sid." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockerfiles" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockerfiles" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0"

ENV PY_VER_NUM="3.4" PY_DEBIAN_SUITE="jessie"

COPY build-image.sh /usr/share/docker/python/3.4/
RUN bash /usr/share/docker/python/3.4/build-image.sh