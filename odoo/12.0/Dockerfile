FROM dockershelf/python:3.9

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="odoo12.0" \
      org.label-schema.description="An Odoo 12.0 image based on Debian sid, Python 3.9 and Node 14." \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

ENV ODOO_VER_NUM="12.0"

COPY odoo.conf /etc/odoo/
COPY docker-entrypoint.sh /usr/local/bin/
COPY build-image.sh library.sh /usr/share/dockershelf/odoo/
RUN bash /usr/share/dockershelf/odoo/build-image.sh

VOLUME /var/lib/odoo /mnt/extra-addons

EXPOSE 8069 8071

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]