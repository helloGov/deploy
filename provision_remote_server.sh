#!/bin/bash

source conf/load_variables.sh

function run()
{
  echo "Running: $@"
  "$@"
}

KEY_ARG="-i $KEY_FILE_PATH"

# remove and copy conf folder to remote server
run ssh $KEY_ARG $SERVER "sudo [ -d /tmp/conf ] && sudo rm -r /tmp/conf"
run scp $KEY_ARG -r conf $SERVER:/tmp/conf

#remove and copy remote script to remove server
run ssh $KEY_ARG $SERVER "sudo [ -f /tmp/$REMOTE_SCRIPT ] && rm -r /tmp/$REMOTE_SCRIPT"
run scp $KEY_ARG $REMOTE_SCRIPT $SERVER:/tmp/$REMOTE_SCRIPT
run ssh $KEYARG $SERVER "sudo chown $USER /tmp/$REMOTE_SCRIPT"

echo "---- Running provision script on remote server ----"
run ssh $KEYARG $SERVER "sudo chmod u+x /tmp/$REMOTE_SCRIPT"
run ssh $KEYARG $SERVER "/tmp/$REMOTE_SCRIPT"
