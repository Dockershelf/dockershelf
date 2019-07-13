FROM %%BASE_IMAGE%%

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="odoo%%ODOO_VERSION%%" \
      org.label-schema.description="An Odoo %%ODOO_VERSION%% image based on Debian %%DEBIAN_RELEASE%%, Python %%PYTHON_VERSION%% and Node %%NODE_VERSION%%." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ENV ODOO_VER_NUM="%%ODOO_VERSION%%" NODE_VER_NUM="%%NODE_VERSION%%"

COPY odoo.conf /etc/odoo/
COPY docker-entrypoint.sh /usr/local/bin/
COPY build-image-node.sh /usr/share/dockershelf/node/build-image.sh
COPY library.sh /usr/share/dockershelf/node/
COPY build-image.sh library.sh /usr/share/dockershelf/odoo/

RUN bash /usr/share/dockershelf/node/build-image.sh
RUN bash /usr/share/dockershelf/odoo/build-image.sh

VOLUME /var/lib/odoo /mnt/extra-addons

EXPOSE 8069 8071

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]