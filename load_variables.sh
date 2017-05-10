# default values
SERVER=104.199.132.136
APP_DIR=/var/www/hellogov
ARCHIVE_DIR=/home/hellogov/archive
GIT_URL="git://github.com/helloGov/singleAction"
GIT_DEPLOY_URL="git://github.com/helloGov/deploy"
REMOTE_SCRIPT_PATH=/tmp
KEY_FILE_PATH=~/.ssh/gc
DOMAIN_NAME=staging.heyagov.org
EMAIL=hellogoveng@gmail.com

function usage {
	echo "Usage: $0 -server=\$SERVER_IP_ADDRESS -keyfile=\$PATH_TO_KEY_FILE"
	echo "Defaults to server: $SERVER, keyfile: $KEY_FILE_PATH"
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
    -domain=*|--domain=*)
    DOMAIN_NAME="${i#*=}"
    shift
    ;;
    *)
    usage
    ;;
esac
done
