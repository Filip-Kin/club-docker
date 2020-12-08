#!/bin/bash
cd /home/container
rm .club-server-entrypoint.sh

# Output Current Node Version
echo "Node.JS Version: $(node --version)"
echo "NPM Version: $(npm --version)"

echo ""

echo_cmd() {
  echo "container@c:/home/container$ $*"
  $*
}

if [ -n "$GIT_REPO" ]; then
  echo "Git Repository: $GIT_REPO"
  if [ -e ".git" ]; then
    git remote set-url "$(git remote)" "$GIT_REPO"
    git checkout . --force
    git checkout ${GIT_BRANCH}
    git pull --recurse-submodules -q
  else
    git init .
    git remote add origin "$(git remote)"
    git pull origin ${GIT_BRANCH}
  fi
fi

echo_cmd npm install -D

if [ -n "$GIT_REPO" ]; then
  if [ -n "$BUILD_SCRIPT" ]; then
    BUILD_SCRIPT_MODIFIED=`eval echo $(echo ${BUILD_SCRIPT} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
    echo_cmd ${BUILD_SCRIPT_MODIFIED}
  fi
fi

START_SCRIPT_MODIFIED=`eval echo $(echo ${START_SCRIPT} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

echo "Starting Node.JS"
echo_cmd ${START_SCRIPT_MODIFIED}
