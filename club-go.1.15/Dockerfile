FROM golang:1.15.6-alpine3.12

RUN apk add --no-cache --update git bash openssh-client ffmpeg \
    && adduser -u 997 -D -h /home/container container

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh", "/entrypoint.sh"]
