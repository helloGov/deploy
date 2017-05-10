#!/bin/bash
#set -e

echo "running $0 on remote server"

source /tmp/deploy/load_variables.sh

# Pull deploy scripts
echo "updating deploy scripts"
cd $REMOTE_SCRIPT_PATH/deploy
git pull origin master

# load the vars again in case any changed during git pull
source $REMOTE_SCRIPT_PATH/deploy/load_variables.sh

set -x
whoami
pm2 stop $REMOTE_SCRIPT_PATH/deploy/ecosystem.config.json


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
cp $REMOTE_SCRIPT_PATH/deploy/secrets.js ./
npm install #--production
#npm prune --production
npm run build
npm rebuild node-sass

pm2 start $REMOTE_SCRIPT_PATH/deploy/ecosystem.config.json