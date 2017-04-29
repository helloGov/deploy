#!/bin/bash
#set -e

echo "running $0 on remote server"
source /tmp/load_variables.sh

set -x
whoami
##TODO: stop PM2 process -- how do we know the process ID?
pm2 stop $REMOTE_SCRIPT_PATH/ecosystem.config.json

# place old code in
arch_current_path=$ARCHIVEDIR/$(date +%m_%d_%Y_%H_%M)


# Pull latest code
if [ -d $APP_DIR/app ]; then
  echo "updating app"
  cd $APP_DIR/app
  mkdir -p $arch_current_path
  mv * $arch_current_path
  git pull
else
  echo "cloning app"
  git clone $GIT_URL $APP_DIR/app
  cd $APP_DIR/app
fi

# Install dependencies
cp $REMOTE_SCRIPT_PATH/secrets.js ./
npm install #--production
#npm prune --production
npm run build

pm2 start $REMOTE_SCRIPT_PATH/ecosystem.config.json
