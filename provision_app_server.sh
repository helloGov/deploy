source /tmp/load_variables.sh

sudo apt-get update -y
sudo apt-get install build-essential -y
sudo apt-get install git -y
sudo apt-get install rubygems -y
sudo apt-get install rubygems-integration -y

# SSL
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto

# FIXME: don't hard code domain name
./certbot-auto certonly --standalone -d $DOMAIN_NAME
#sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

# nginx
sudo apt-get install nginx
cp $REMOTE_SCRIPT_PATH/deploy/nginx/hellogov.conf /etc/nginx/sites-available/hellogov.conf
ln -s /etc/nginx/sites-available/hellogov.conf /etc/nginx/sites-enabled/hellogov.conf
sudo service nginx reload

sudo useradd -m hellogov

sudo mkdir -p $APP_DIR
sudo chown hellogov:hellogov $APP_DIR
sudo -u hellogov mkdir -p $ARCHIVE_DIR

git clone $GIT_DEPLOY_URL $REMOTE_SCRIPT_PATH/deploy

cd /home/hellogov
#sudo -u hellogov npm install pm2@latest -g

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo apt-get install npm -y
sudo npm install pm2@latest -g
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo gem install sass
