FROM scratch

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="debian-bullseye" \
      org.label-schema.description="A Debian bullseye minimal image built from scratch." \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="bullseye" \
    DEBIAN_SUITE="testing"

ADD base /

CMD ["/bin/bash"]