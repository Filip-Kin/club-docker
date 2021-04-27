#!/bin/bash
cd /home/container

# Output Current Node Version
echo "Starting server at $(date +"%Y-%m-%d %I:%M:%S") UTC" |& tee /home/container/server.log
echo "Node.JS Version: $(node --version)" |& tee -a /home/container/server.log
echo "NPM Version: $(npm --version)" |& tee -a /home/container/server.log

echo "" |& tee -a /home/container/server.log

if [ ! -e "app" ]; then
  mkdir app
fi

cd app

GIT_CHANGED=0

# environment variables for everything, copied muiltiple times
# just in case
export PORT=${SERVER_PORT}
export HTTP_PORT=${SERVER_PORT}

export CLUB_HOST=172.18.0.1
export RETHINKDB_HOST=${CLUB_HOST}
export MYSQL_HOST=${CLUB_HOST}
export REDIS_HOST=${CLUB_HOST}

if [ -n "${GIT_REPO}" ]; then
  echo "Git Repository: ${GIT_REPO}" |& tee -a /home/container/server.log
  if [ -e ".git" ]; then
    git remote set-url "$(git remote)" "${GIT_REPO}" |& tee -a /home/container/server.log
    git reset --hard |& tee -a /home/container/server.log
    git checkout "${GIT_BRANCH}" |& tee -a /home/container/server.log
    git pull origin "${GIT_BRANCH}" --recurse-submodules | grep -q -v 'Already up-to-date.' && GIT_CHANGED=1 |& tee -a /home/container/server.log
  else
    git init . |& tee -a /home/container/server.log
    git remote add origin "${GIT_REPO}" |& tee -a /home/container/server.log
    git pull origin "${GIT_BRANCH}" --recurse-submodules -q |& tee -a /home/container/server.log
  fi
fi

echo $ npm install -D |& tee -a /home/container/server.log
npm install -D |& tee -a /home/container/server.log

if [ -n "${GIT_REPO}" ] && [ -n "${BUILD_SCRIPT}" ]; then
  if [ ! -e "/home/container/.build.config" ]; then
    GIT_CHANGED=1
  else
    if ! [ "${GIT_REPO};${GIT_BRANCH};${BUILD_SCRIPT}" = "$(cat /home/container/.build.config)" ]; then
      GIT_CHANGED=1
    fi
  fi
  echo "${GIT_REPO};${GIT_BRANCH};${BUILD_SCRIPT}" > /home/container/.build.config
  if [ "$GIT_CHANGED" = "1" ]; then
    BUILD_SCRIPT_MODIFIED=`eval echo $(echo ${BUILD_SCRIPT} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
    echo $ "${BUILD_SCRIPT_MODIFIED}" |& tee -a /home/container/server.log
    ${BUILD_SCRIPT_MODIFIED} |& tee -a /home/container/server.log
  fi
fi

START_SCRIPT_MODIFIED=`eval echo $(echo ${START_SCRIPT} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

if [ -n "${DOMAIN}" ]; then
  echo Notifying Club Sever of the domain configuration. |& tee -a /home/container/server.log
  wget "http://${CLUB_HOST}:1000/proxy?domain=${DOMAIN}&hostname=${HOSTNAME}" -O - |& tee -a /home/container/server.log
fi

echo "Starting Server" |& tee -a /home/container/server.log

export NODE_ENV=production

echo $ "${START_SCRIPT_MODIFIED}" |& tee -a /home/container/server.log
${START_SCRIPT_MODIFIED} |& tee -a /home/container/server.log
