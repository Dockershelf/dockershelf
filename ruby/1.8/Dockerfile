FROM dockershelf/debian:sid
MAINTAINER Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="ruby1.8" \
      org.label-schema.description="A Ruby 1.8 image based on Debian sid." \
      org.label-schema.url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/LuisAlejandro/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1"

ENV RUBY_VER_NUM="1.8" RUBY_DEBIAN_SUITE="wheezy"

COPY build-image.sh /usr/share/dockershelf/ruby/
RUN bash /usr/share/dockershelf/ruby/build-image.sh

CMD ["ruby"]