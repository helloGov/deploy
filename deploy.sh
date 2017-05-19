#!/bin/bash

source load_variables.sh

function run()
{
  echo "Running: $@"
  "$@"
}

KEY_ARG="-i $KEY_FILE_PATH"

# remove and copy secrets file to remote server
run ssh $KEY_ARG $SERVER "sudo [ -f $REMOTE_SCRIPT_PATH/deploy/secrets.js ] && rm $REMOTE_SCRIPT_PATH/deploy/secrets.js"
run scp $KEY_ARG secrets.js $SERVER:$REMOTE_SCRIPT_PATH/deploy/secrets.js
run ssh $KEYARG $SERVER "sudo chmod o+w $REMOTE_SCRIPT_PATH/deploy/secrets.js"
run ssh $KEYARG $SERVER "sudo chown hellogov:hellogov $REMOTE_SCRIPT_PATH/deploy/secrets.js"

echo
echo "---- Running deployment script on remote server ----"
run ssh $KEYARG $SERVER "sudo chmod u+x $REMOTE_SCRIPT_PATH/deploy/update_application.js"
run ssh $KEYARG $SERVER "sudo -H -u hellogov $REMOTE_SCRIPT_PATH/deploy/update_application.sh"
