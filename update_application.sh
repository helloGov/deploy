#!/bin/bash
#set -e

echo "running $0 on remote server"

source /home/hellogov/deploy/conf/load_variables.sh

set -x
whoami
pm2 stop $REMOTE_SCRIPT_PATH/conf/ecosystem.config.json --env production

# place old code in
arch_current_path=$ARCHIVE_DIR/$(date +%m_%d_%Y_%H_%M)

# Pull latest code
if [ -d $APP_DIR/app ]; then
  echo "updating app"
  cd $APP_DIR/app
  mkdir -p $arch_current_path
  cp  -r * $arch_current_path
  git pull
else
  echo "cloning app"
  git clone $GIT_URL $APP_DIR/app
  cd $APP_DIR/app
fi

# Install dependencies
cp $REMOTE_SCRIPT_PATH/conf/secrets.js ./conf/
cp $REMOTE_SCRIPT_PATH/conf/env.js ./conf/env.js
npm install
npm run build
npm rebuild node-sass

pm2 start $REMOTE_SCRIPT_PATH/conf/ecosystem.config.json --env production
