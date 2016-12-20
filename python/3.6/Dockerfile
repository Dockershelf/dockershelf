FROM luisalejandro/debian:sid
MAINTAINER Luis Alejandro Martínez Faneyth <luis@huntingbears.com.ve>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL ve.com.huntingbears.build-date=${BUILD_DATE} \
      ve.com.huntingbears.name="python3.6" \
      ve.com.huntingbears.description="A Python 3.6 image based on Debian Sid." \
      ve.com.huntingbears.url="https://github.com/LuisAlejandro/dockerfiles" \
      ve.com.huntingbears.vcs-ref=${VCS_REF} \
      ve.com.huntingbears.vcs-url="https://github.com/LuisAlejandro/dockerfiles" \
      ve.com.huntingbears.vendor="Luis Alejandro Martínez Faneyth" \
      ve.com.huntingbears.version=${VERSION} \
      ve.com.huntingbears.schema-version="1.0"

ENV PY_VER_NUM="3.6" PY_DEBIAN_SUITE="experimental"

COPY *.sh /usr/share/docker/python/
RUN bash /usr/share/docker/python/build-image.sh