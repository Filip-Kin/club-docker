#!/bin/bash
cd /home/container

if [ ! -e "html" ]; then
  mkdir html
fi

cd html

if [ -n "${DOMAIN}" ]; then
  echo Notifying Club Sever of the domain configuration.
  wget "http://${CLUB_HOST}:1000/web?domain=${DOMAIN}&hostname=${HOSTNAME}&root=html" -O -
fi

exit 0
