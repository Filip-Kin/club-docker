#!/bin/bash
cd /home/container

echo "Starting server at $(date +"%Y-%m-%d %I:%M:%S") UTC" |& tee /home/container/server.log

if [ ! -e "app" ]; then
  mkdir app
fi

cd app

export CLUB_HOST=172.18.0.1

if [ -n "${DOMAIN}" ]; then
  echo Notifying Club Sever of the domain configuration. |& tee -a /home/container/server.log
  wget "http://${CLUB_HOST}:1000/static?domain=${DOMAIN}&hostname=${HOSTNAME}&root=app" -O - -q |& tee -a /home/container/server.log
fi

echo "Complete. This server doesn't run any server-side logic here, so it will shut off to save resources." |& tee -a /home/container/server.log
echo "It will say crashed state but EVERYTHING WAS SUCCESSFUL" |& tee -a /home/container/server.log
