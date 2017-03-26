#!/bin/bash
set -e

source load_variables.sh

function run()
{
  echo "Running: $@"
  "$@"
}

KEYARG="-i $KEY_FILE_PATH"

run scp $KEYARG deploy/work.sh $SERVER:$REMOTE_SCRIPT_PATH
echo
echo "---- Running deployment script on remote server ----"
run ssh $KEYARG $SERVER bash "sudo -u hellogov $REMOTE_SCRIPT_PATH"