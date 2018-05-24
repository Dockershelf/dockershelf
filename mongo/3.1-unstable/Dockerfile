FROM dockershelf/debian:unstable
MAINTAINER Luis Alejandro Martínez Faneyth <luis@huntingbears.com.ve>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="mongo3.1" \
      org.label-schema.description="A Mongo 3.1 image based on Debian unstable." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1"

ENV MONGO_VER_NUM="3.1" PYTHONIOENCODING="UTF-8"

COPY *.sh /usr/share/dockershelf/mongo/
RUN bash /usr/share/dockershelf/mongo/build-image.sh

CMD ["/bin/bash"]