FROM dockershelf/debian:sid

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="ruby1.9.1" \
      org.label-schema.description="A Ruby 1.9.1 image based on Debian sid." \
      org.label-schema.url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/Dockershelf/dockershelf" \
      org.label-schema.vendor="Luis Alejandro Martínez Faneyth" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      maintainer="Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ENV RUBY_VER_NUM="1.9.1" RUBY_DEBIAN_SUITE="wheezy-security"

COPY build-image.sh library.sh /usr/share/dockershelf/ruby/
RUN bash /usr/share/dockershelf/ruby/build-image.sh

CMD ["ruby"]