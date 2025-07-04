FROM dockershelf/debian:bookworm

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="go1.22.12" \
      org.label-schema.description="A Go 1.22.12 image based on Debian bookworm" \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="go1.22.12" \
      org.opencontainers.image.description="A Go 1.22.12 image based on Debian bookworm" \
      org.opencontainers.image.url="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.vendor="Luis Alejandro Martínez Faneyth" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ENV GO_VER_NUM="1.22.12" GO_DEBIAN_SUITE="bookworm" \
    PATH="${PATH}:/usr/local/go/bin"

COPY build-image.sh library.sh /usr/share/dockershelf/go/
RUN bash /usr/share/dockershelf/go/build-image.sh

CMD ["go"]