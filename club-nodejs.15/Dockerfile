FROM mhart/alpine-node:15

RUN apk add --no-cache --update git bash python3 gcc g++ make \
    && adduser -D -h /home/container container

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
