FROM dockershelf/debian:sid

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"
LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="latex-full" \
      org.label-schema.description="A Latex (full) image based on Debian sid." \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1"

ENV LATEX_VER_NUM="full"

COPY sample.tex /root/
COPY build-image.sh library.sh /usr/share/dockershelf/latex/
RUN bash /usr/share/dockershelf/latex/build-image.sh

CMD ["/bin/bash"]