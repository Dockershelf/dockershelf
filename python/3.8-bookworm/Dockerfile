FROM dockershelf/debian:bookworm

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="python3.8" \
      org.label-schema.description="A Python 3.8 image based on Debian bookworm" \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="python3.8" \
      org.opencontainers.image.description="A Python 3.8 image based on Debian bookworm" \
      org.opencontainers.image.url="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.vendor="Luis Alejandro Martínez Faneyth" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ENV PYTHON_VER_NUM="3.8" PYTHON_DEBIAN_SUITE="bookworm" \
    PYTHONIOENCODING="UTF-8" PIP_BREAK_SYSTEM_PACKAGES=1 \
    PYTHONPATH="/usr/lib/python3.8/dist-packages:/usr/lib/python3.8/site-packages"

COPY build-image.sh library.sh /usr/share/dockershelf/python/
RUN bash /usr/share/dockershelf/python/build-image.sh

CMD ["python"]