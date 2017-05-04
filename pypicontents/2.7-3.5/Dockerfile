FROM dockershelf/python:2.7-3.5
MAINTAINER Luis Alejandro Martínez Faneyth <luis@huntingbears.com.ve>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="pypicontents-python2.7-3.5" \
      org.label-schema.description="A PyPIContents image based on Python 2.7 and 3.5." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1"

RUN pip2.7 install pypicontents && pip3.5 install pypicontents

CMD ["/bin/bash"]