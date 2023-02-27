#!/bin/bash
cd /home/container

# Output Current Node Version
echo "Node.JS Version: $(node --version)"
echo "NPM Version: $(npm --version)"

echo ""

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
  echo "Git Repository: ${GIT_REPO}"
  if [ -e ".git" ]; then
    git remote set-url "$(git remote)" "${GIT_REPO}"
    git reset --hard
    git checkout "${GIT_BRANCH}"
    git pull origin "${GIT_BRANCH}" --recurse-submodules | grep -q -v 'Already up-to-date.' && GIT_CHANGED=1
  else
    git init .
    git remote add origin "${GIT_REPO}"
    git pull origin "${GIT_BRANCH}" --recurse-submodules -q
  fi
fi

if [ -e "yarn.lock" ]; then
  echo $ yarn
  yarn
elif [ -e "package.json" ]; then
  echo $ npm install -D
  npm install -D
fi

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
    echo $ "${BUILD_SCRIPT_MODIFIED}"
    ${BUILD_SCRIPT_MODIFIED}
  fi
fi

START_SCRIPT_MODIFIED=`eval echo $(echo ${START_SCRIPT} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

if [ -n "${DOMAIN}" ]; then
  echo Notifying Club Sever of the domain configuration.
  wget "http://${CLUB_HOST}:1000/proxy?domain=${DOMAIN}&hostname=${HOSTNAME}" -O -
fi

echo "Starting Server"

export NODE_ENV=production

echo $ "${START_SCRIPT_MODIFIED}"
${START_SCRIPT_MODIFIED}
