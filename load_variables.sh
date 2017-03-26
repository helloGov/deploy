# default values
SERVER=104.197.168.71
APP_DIR=/var/www/hellogov
ARCHIVE_DIR=/home/hellogov/archive
GIT_URL=git://github.com/helloGov/singleAction
REMOTE_SCRIPT_PATH=/tmp/deploy-myapp.sh
KEY_FILE_PATH=~/.ssh/hellogov.id

function usage {
	echo "Usage: $0 -server=\$SERVER_IP_ADDRESS -key=\$PATH_TO_KEY_FILE"
	echo "Defaults to server: $SERVER, key: $KEY_FILE_PATH"
}

#parse args
for i in "$@"
do
case $i in
    -server=*|--server=*|-s=*)
    SERVER="${i#*=}"
    shift 
    ;;
    -keyfile=*|--keyfile=*)
    KEY_FILE_PATH="${i#*=}"
    shift 
    ;;
    *)
    usage 
    ;;
esac
done