FROM dockershelf/debian:sid

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="mongo3.6" \
      org.label-schema.description="A Mongo 3.6 image based on Debian sid." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ENV MONGO_VER_NUM="3.6" MONGO_DEBIAN_SUITE="stretch"

COPY aggregate.js articles.js /root/
COPY docker-entrypoint.sh /usr/local/bin/
COPY build-image.sh library.sh /usr/share/dockershelf/mongo/
RUN bash /usr/share/dockershelf/mongo/build-image.sh

VOLUME /data/db /data/configdb

EXPOSE 27017

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mongod"]