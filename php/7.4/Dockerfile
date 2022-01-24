FROM dockershelf/debian:sid

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="php7.4" \
      org.label-schema.description="A PHP 7.4 image based on Debian sid." \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

ENV PHP_VER_NUM="7.4" PHP_DEBIAN_SUITE="bullseye"

COPY docker-entrypoint.sh apache2-foreground /usr/local/bin/
COPY build-image.sh library.sh /usr/share/dockershelf/php/
RUN bash /usr/share/dockershelf/php/build-image.sh

VOLUME /var/www/html
WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]