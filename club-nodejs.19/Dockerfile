FROM node:16-alpine

RUN apk add --no-cache --update git bash python3 gcc g++ make openssh-client ffmpeg curl \
    && adduser -u 997 -D -h /home/container container

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh", "/entrypoint.sh"]
