#!/bin/bash

source load_variables.sh

function run()
{
  echo "Running: $@"
  "$@"
}

KEY_ARG="-i $KEY_FILE_PATH"

# remove and copy secrets file to remote server
run ssh $KEY_ARG $SERVER "sudo [ -f $HOME/secrets.js ] && rm $HOME/secrets.js"
run scp $KEY_ARG secrets.js $SERVER:$REMOTE_SCRIPT_PATH/deploy

echo
echo "---- Running deployment script on remote server ----"
run ssh $KEYARG $SERVER "sudo -H -u hellogov $REMOTE_SCRIPT_PATH/deploy/update_application.sh"
