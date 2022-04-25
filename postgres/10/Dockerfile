FROM dockershelf/debian:sid

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="postgres10" \
      org.label-schema.description="A Postgres 10 image based on Debian sid." \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="postgres10" \
      org.opencontainers.image.description="An Postgres 10 image based on Debian sid" \
      org.opencontainers.image.url="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.vendor="Luis Alejandro Martínez Faneyth" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

ENV POSTGRES_VER_NUM="10" \
	PATH="${PATH}:/usr/lib/postgresql/10/bin" \
	PGDATA="/var/lib/postgresql/data"

COPY docker-entrypoint.sh /usr/local/bin/
COPY build-image.sh library.sh /usr/share/dockershelf/postgres/
RUN bash /usr/share/dockershelf/postgres/build-image.sh

VOLUME /var/lib/postgresql/data

EXPOSE 5432
STOPSIGNAL SIGINT

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]