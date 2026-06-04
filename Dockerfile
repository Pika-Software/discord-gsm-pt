FROM python:3.13-alpine

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apk add --update --no-cache git bash && \
    rm -rf /var/cache/apk/* && \
    ln -sf python3 /usr/bin/python

RUN adduser -D -h /home/container container

USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container

RUN python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools

ENTRYPOINT  [ "/bin/bash", "/entrypoint.sh" ]
