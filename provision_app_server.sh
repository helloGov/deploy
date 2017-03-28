source /tmp/load_variables.sh

sudo apt-get update -y
sudo apt-get install build-essential -y 
sudo apt-get install git -y
sudo apt-get install rubygems-integration -y

sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

sudo useradd -m hellogov


sudo mkdir -p $APP_DIR
sudo chown hellogov:hellogov $APP_DIR
sudo - u hellogov mkdir -p $ARCHIVE_DIR

cd /home/hellogov
#sudo -u hellogov npm install pm2@latest -g

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo apt-get install npm -y 
sudo npm install pm2@latest -g
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo gem install sass
