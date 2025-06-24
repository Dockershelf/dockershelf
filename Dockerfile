FROM dockershelf/python:3.12
LABEL maintainer "Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ARG UID=1000
ARG GID=1000

RUN apt-get update && \
    apt-get install sudo python3.12-venv bundler

ADD requirements.txt /root/
RUN pip3 install -r /root/requirements.txt
RUN rm -rf /root/requirements.txt

RUN EXISTUSER=$(getent passwd | awk -F':' '$3 == '$UID' {print $1}') && \
    [ -n "${EXISTUSER}" ] && deluser ${EXISTUSER} || true

RUN EXISTGROUP=$(getent group | awk -F':' '$3 == '$GID' {print $1}') && \
    [ -n "${EXISTGROUP}" ] && delgroup ${EXISTGROUP} || true

RUN groupadd -g "${GID}" dockershelf || true
RUN useradd -u "${UID}" -g "${GID}" -ms /bin/bash dockershelf

RUN echo "dockershelf ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dockershelf

USER dockershelf

RUN mkdir -p /home/dockershelf/app

WORKDIR /home/dockershelf/app

CMD tail -f /dev/null