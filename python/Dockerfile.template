FROM %%BASE_IMAGE%%

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="python%%PYTHON_VERSION%%" \
      org.label-schema.description="A Python %%PYTHON_VERSION%% image based on Debian %%DEBIAN_RELEASE%%." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ENV PYTHON_VER_NUM="%%PYTHON_VERSION%%" PYTHON_DEBIAN_SUITE="%%PYTHON_DEBIAN_SUITE%%" \
	PYTHONIOENCODING="UTF-8"

COPY build-image.sh library.sh /usr/share/dockershelf/python/
RUN bash /usr/share/dockershelf/python/build-image.sh

CMD ["python"]