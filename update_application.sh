#!/bin/bash
set -e

source ./load_variables.sh

set -x

##TODO: stop PM2 process -- how do we know the process ID? 
pm2 stop 0

# place old code in 
arch_current_path=$ARCHIVEDIR/$(date +%m_%d_%Y_%H_%M)


# Pull latest code
if [[ -e $APP_DIR/app ]]; then
  cd $APP_DIR/app
  mv * $arch_current_path
  git pull
else
  git clone $GIT_URL $APP_DIR/app
  cd $APP_DIR/app
fi

# Install dependencies
npm install --production
npm prune --production

# Restart pm2
