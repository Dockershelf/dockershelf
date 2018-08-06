FROM dockershelf/python:2.7
MAINTAINER Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="odoo9.0" \
      org.label-schema.description="An Odoo 9.0 image based on Debian sid and Python 2.7." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf-extras" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf-extras" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1"

ENV ODOO_VER_NUM="9.0"

COPY odoo.conf /etc/odoo/
COPY docker-entrypoint.sh /usr/local/bin/
COPY build-image-node.sh /usr/share/dockershelf/node/build-image.sh
COPY build-image.sh library.sh /usr/share/dockershelf-extras/odoo/

RUN bash /usr/share/dockershelf/node/build-image.sh
RUN bash /usr/share/dockershelf-extras/odoo/build-image.sh

VOLUME /var/lib/odoo /mnt/extra-addons

EXPOSE 8069 8071

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]