#!/bin/bash

source load_variables.sh

function run()
{
  echo "Running: $@"
  "$@"
}

KEY_ARG="-i $KEY_FILE_PATH"

run ssh $KEY_ARG $SERVER "sudo [ -f $REMOTE_SCRIPT_PATH/load_variables.sh ] && rm $REMOTE_SCRIPT_PATH/load_variables.sh"
run ssh $KEY_ARG $SERVER "sudo [ -f $REMOTE_SCRIPT_PATH/update_application.sh ] && rm $REMOTE_SCRIPT_PATH/update_application.sh"
run ssh $KEY_ARG $SERVER "sudo [ -f $REMOTE_SCRIPT_PATH/secrets.js ] && rm $REMOTE_SCRIPT_PATH/secrets.js"
run ssh $KEY_ARG $SERVER "sudo [ -f $REMOTE_SCRIPT_PATH/ecosystem.config.json ] && rm $REMOTE_SCRIPT_PATH/ecosystem.config.json"

run scp $KEY_ARG load_variables.sh update_application.sh secrets.js ecosystem.config.json $SERVER:$REMOTE_SCRIPT_PATH
run ssh $KEY_ARG $SERVER "sudo chown hellogov:hellogov $REMOTE_SCRIPT_PATH/load_variables.sh"
run ssh $KEY_ARG $SERVER "sudo chown hellogov:hellogov $REMOTE_SCRIPT_PATH/update_application.sh"
run ssh $KEY_ARG $SERVER "sudo chown hellogov:hellogov $REMOTE_SCRIPT_PATH/secrets.js"
run ssh $KEY_ARG $SERVER "sudo chown hellogov:hellogov $REMOTE_SCRIPT_PATH/ecosystem.config.json"
run ssh $KEY_ARG $SERVER "sudo chmod u+x $REMOTE_SCRIPT_PATH/update_application.sh"

echo
echo "---- Running deployment script on remote server ----"
run ssh $KEYARG $SERVER "sudo -H -u hellogov $REMOTE_SCRIPT_PATH/update_application.sh"
run ssh $KEY_ARG $SERVER "sudo rm $REMOTE_SCRIPT_PATH/load_variables.sh $REMOTE_SCRIPT_PATH/update_application.sh"