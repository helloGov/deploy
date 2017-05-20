#!/bin/bash

source conf/load_variables.sh

function run()
{
  echo "Running: $@"
  "$@"
}

KEY_ARG="-i $KEY_FILE_PATH"

# remove and copy conf folder to remote server
run ssh $KEY_ARG $SERVER "sudo [ -d $REMOTE_SCRIPT_PATH/conf ] && sudo rm -r $REMOTE_SCRIPT_PATH/conf"
run scp $KEY_ARG -r conf $SERVER:$REMOTE_SCRIPT_PATH/conf
run ssh $KEYARG $SERVER "sudo find $REMOTE_SCRIPT_PATH/conf -type f -exec chown hellogov:hellogov {} \;"

#remove and copy remote script to remove server
run ssh $KEY_ARG $SERVER "sudo [ -f $REMOTE_SCRIPT_PATH/$REMOTE_SCRIPT ] && rm -r $REMOTE_SCRIPT_PATH/$REMOTE_SCRIPT"
run scp $KEY_ARG $REMOTE_SCRIPT $SERVER:$REMOTE_SCRIPT_PATH/$REMOTE_SCRIPT
run ssh $KEYARG $SERVER "sudo chown hellogov $REMOTE_SCRIPT_PATH/$REMOTE_SCRIPT"

echo "---- Running deployment script on remote server ----"
run ssh $KEYARG $SERVER "sudo chmod u+x $REMOTE_SCRIPT_PATH/$REMOTE_SCRIPT"
run ssh $KEYARG $SERVER "sudo -H -u hellogov $REMOTE_SCRIPT_PATH/$REMOTE_SCRIPT"
