#!/bin/bash
cd /home/container

if [ ! -e "app" ]; then
  mkdir app
fi

cd app

export CLUB_HOST=172.18.0.1

if [ -n "${DOMAIN}" ]; then
  echo Notifying Club Sever of the domain configuration.
  wget "http://${CLUB_HOST}:1000/static?domain=${DOMAIN}&hostname=${HOSTNAME}&root=app" -O - -q
fi

echo "Complete. This server doesn't run any server-side logic here, so it will shut off to save resources."
echo "It will say crashed state but EVERYTHING WAS SUCCESSFUL"
