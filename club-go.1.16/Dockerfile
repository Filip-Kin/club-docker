FROM petronetto/opencv-alpine
FROM golang:1.16-alpine3.12

RUN apk add --no-cache --update git openssh-client ffmpeg curl \
    && adduser -u 997 -D -h /home/container container

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh", "/entrypoint.sh"]
