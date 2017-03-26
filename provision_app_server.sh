source ./load_variables.sh

sudo apt-get update -y
sudo apt-get install build-essential -y 

sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

sudo useradd -m hellogov

curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install nodejs -y
sudo ln -s /usr/bin/nodejs /usr/bin/node

sudo mkdir -p $APP_DIR
sudo chown hellogov:hellogov $APP_DIR
sudo mkdir -p $ARCHIVE_DIR
sudo chown hellogov:hellogov $APP_DIR 

cd /home/hellogov
sudo -u hellogov npm install pm2@latest -g
