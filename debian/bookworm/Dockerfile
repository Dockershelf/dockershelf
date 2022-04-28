FROM scratch

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="debian-bookworm" \
      org.label-schema.description="A Debian bookworm minimal image built from scratch." \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="debian-bookworm" \
      org.opencontainers.image.description="A Debian bookworm minimal image built from scratch." \
      org.opencontainers.image.url="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.vendor="Luis Alejandro Martínez Faneyth" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="bookworm" \
    DEBIAN_SUITE="testing"

ADD base /

CMD ["/bin/bash"]