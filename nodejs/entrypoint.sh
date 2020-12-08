#!/bin/bash
cd /home/container

# Output Current Node Version
echo "Node.JS Version: "
node --version
echo "NPM Version: "
npm --version

echo ""
echo "container@c:/home/container$ npm install"
npm install

echo "Starting Node"

# Run the Server
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo "container@c:/home/container$ ${MODIFIED_STARTUP}"
${MODIFIED_STARTUP}