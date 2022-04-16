FROM dockershelf/python:3.9
LABEL maintainer "Luis Alejandro Martínez Faneyth <luis@collagelabs.org>"

RUN apt-get update && \
    apt-get install sudo

RUN echo "Set disable_coredump false" >> /etc/sudo.conf

ADD requirements.txt requirements-dev.txt /root/
RUN pip3 install -r /root/requirements.txt -r /root/requirements-dev.txt
RUN rm -rf /root/requirements.txt /root/requirements-dev.txt

RUN useradd -ms /bin/bash dockershelf
RUN echo "dockershelf ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dockershelf
USER dockershelf
WORKDIR /home/dockershelf/app

CMD tail -f /dev/null