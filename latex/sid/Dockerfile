FROM dockershelf/debian:sid
MAINTAINER Luis Alejandro Martínez Faneyth <luis@huntingbears.com.ve>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL ve.com.huntingbears.build-date=${BUILD_DATE} \
      ve.com.huntingbears.name="latex-debian-sid" \
      ve.com.huntingbears.description="A Latex image based on Debian Sid." \
      ve.com.huntingbears.url="https://github.com/LuisAlejandro/dockershelf" \
      ve.com.huntingbears.vcs-ref=${VCS_REF} \
      ve.com.huntingbears.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      ve.com.huntingbears.vendor="Luis Alejandro Martínez Faneyth" \
      ve.com.huntingbears.version=${VERSION} \
      ve.com.huntingbears.schema-version="1.0"

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install \
        texlive-fonts-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        latex-xcolor