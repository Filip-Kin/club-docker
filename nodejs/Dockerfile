FROM alpine:latest

RUN apk add --no-cache --update git bash npm \
    && adduser -D -h /home/container container

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /.club-server-entrypoint.sh

CMD ["/bin/bash", "/.club-server-entrypoint.sh"]
