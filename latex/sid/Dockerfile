FROM dockershelf/debian:sid
MAINTAINER Luis Alejandro Martínez Faneyth <luis@huntingbears.com.ve>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="latex-debian-sid" \
      org.label-schema.description="A Latex image based on Debian Sid." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1"

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install \
        texlive-fonts-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        latex-xcolor

CMD ["/bin/bash"]