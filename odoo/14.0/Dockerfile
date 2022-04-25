FROM dockershelf/python:3.10

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="odoo14.0" \
      org.label-schema.description="An Odoo 14.0 image based on Debian sid." \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="odoo14.0" \
      org.opencontainers.image.description="An Odoo 14.0 image based on Debian sid." \
      org.opencontainers.image.url="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/Dockershelf/dockershelf" \
      org.opencontainers.image.vendor="Luis Alejandro Martínez Faneyth" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

ENV ODOO_VER_NUM="14.0"
ENV ODOO_RC=/etc/odoo/odoo.conf

COPY odoo.conf /etc/odoo/
COPY docker-entrypoint.sh wait-for-psql.py /usr/local/bin/
COPY build-image.sh library.sh /usr/share/dockershelf/odoo/
RUN bash /usr/share/dockershelf/odoo/build-image.sh

VOLUME /var/lib/odoo /mnt/extra-addons

EXPOSE 8069 8071 8072

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]