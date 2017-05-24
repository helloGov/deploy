source /tmp/conf/load_variables.sh

sudo apt-get update -y
sudo apt-get install build-essential -y
sudo apt-get install git rubygems rubygems-integration -y

# SSL
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto

./certbot-auto certonly --non-interactive --standalone -d $DOMAIN_NAME -d www.$DOMAIN_NAME --email $EMAIL --agree-tos
#sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

sudo groupadd deploy
sudo useradd -m hellogov
sudo usermod -append --groups deploy

sudo mv /tmp/conf/mongodb.pem /etc/ssl/
sudo chgrp deploy /etc/ssl/mongodb.pem

sudo mkdir -p $APP_DIR
sudo chown hellogov:deploy $APP_DIR
sudo -u hellogov mkdir -p $APP_DIR
sudo -u hellogov mkdir -p $ARCHIVE_DIR

sudo -u hellogov git clone $GIT_DEPLOY_URL $REMOTE_SCRIPT_PATH
sudo chown hellogov:hellogov $REMOTE_SCRIPT_PATH
sudo chmod o+w $REMOTE_SCRIPT_PATH
find $REMOTE_SCRIPT_PATH/*.sh -type f -exec sudo chmod u+x  {} \; 

sudo -u hellogov sed -i -e 's/###DOMAIN_NAME###/'"$DOMAIN_NAME"'/g' $REMOTE_SCRIPT_PATH/conf/nginx/hellogov.conf

# nginx
sudo apt-get install nginx -y
sudo cp $REMOTE_SCRIPT_PATH/conf/nginx/hellogov.conf /etc/nginx/sites-available/hellogov.conf
sudo ln -s /etc/nginx/sites-available/hellogov.conf /etc/nginx/sites-enabled/hellogov.conf
sudo service nginx reload

cd /home/hellogov

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo npm install pm2@latest -g
sudo gem install sass
