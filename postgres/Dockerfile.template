FROM %%BASE_IMAGE%%

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="postgres%%POSTGRES_VERSION%%" \
      org.label-schema.description="A Postgres %%POSTGRES_VERSION%% image based on Debian %%DEBIAN_RELEASE%%." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ENV POSTGRES_VER_NUM="%%POSTGRES_VERSION%%" \
	PATH="${PATH}:/usr/lib/postgresql/%%POSTGRES_VERSION%%/bin" \
	PGDATA="/var/lib/postgresql/data"

COPY docker-entrypoint.sh /usr/local/bin/
COPY build-image.sh library.sh /usr/share/dockershelf/postgres/
RUN bash /usr/share/dockershelf/postgres/build-image.sh

VOLUME /var/lib/postgresql/data

EXPOSE 5432

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]