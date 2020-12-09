#!/bin/bash
cd /home/container

# Output Current Node Version
echo "Node.JS Version: $(node --version)"
echo "NPM Version: $(npm --version)"

echo ""

PID=

if [ ! -e "app" ]; then
  mkdir app
fi

cd app

GIT_CHANGED=0

if [ -n "$GIT_REPO" ]; then
  echo "Git Repository: $GIT_REPO"
  if [ -e ".git" ]; then
    git remote set-url "$(git remote)" "${GIT_REPO}"
    git checkout .
    git checkout "${GIT_BRANCH}"
    git pull origin "${GIT_BRANCH}" --recurse-submodules -q | grep -q -v 'Already up-to-date.' && GIT_CHANGED=1
  else
    git init .
    git remote add origin "${GIT_REPO}"
    git pull origin "${GIT_BRANCH}" --recurse-submodules -q
  fi
fi

export NODE_ENV=production

npm install -D

if [ -n "$GIT_REPO" ] && [ -n "$BUILD_SCRIPT" ]; then
  if [ ! -e "/home/container/.build.config" ]; then
    GIT_CHANGED=1
  else
    if ! [ "$GIT_REPO;$GIT_BRANCH;$BUILD_SCRIPT" = "$(cat /home/container/.build.config)" ]; then
      GIT_CHANGED=1
    fi
  fi
  echo "$GIT_REPO;$GIT_BRANCH;$BUILD_SCRIPT" > /home/container/.build.config
  if [ "$GIT_CHANGED" = "1" ]; then
    BUILD_SCRIPT_MODIFIED=`eval echo $(echo ${BUILD_SCRIPT} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
    ${BUILD_SCRIPT_MODIFIED}
  fi
fi

START_SCRIPT_MODIFIED=`eval echo $(echo ${START_SCRIPT} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

if [ -n "${DOMAIN}" ]; then
  wget "http://${SERVER_IP}:1000/node?domain=${DOMAIN}&hostname=${HOSTNAME}" -O -
fi

echo "Starting Node.JS"

export HTTP_PORT=$SERVER_PORT
export PORT=$SERVER_PORT

${START_SCRIPT_MODIFIED} &
PID=$!

trap 'kill $PID; exit' INT

wait
