FROM %%BASE_IMAGE%%

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="php%%PHP_VERSION%%" \
      org.label-schema.description="A PHP %%PHP_VERSION%% image based on Debian %%DEBIAN_RELEASE%%." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ENV PHP_VER_NUM="%%PHP_VERSION%%" PHP_DEBIAN_SUITE="%%PHP_DEBIAN_SUITE%%"

COPY docker-entrypoint.sh apache2-foreground /usr/local/bin/
COPY build-image.sh library.sh /usr/share/dockershelf/php/
RUN bash /usr/share/dockershelf/php/build-image.sh

VOLUME /var/www/html
WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]