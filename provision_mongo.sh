#expects ubuntu 16.04
# expects a firewall rule opening port 27017 to application servers 
source /tmp/load_variables.sh
source /tmp/secrets.sh

# Install necessary components
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update -y
sudo apt-get install mongodb-org build-essential -y

#Create admin user
sudo service mongod start
mongo localhost/admin --eval "db.createUser({user:'$DB_ADMIN_USER',pwd:'$DB_ADMIN_PASSWORD',roles:[{role:'userAdminAnyDatabase',db:'admin'}]})"
sudo service mongod stop

# Install TLS certificate, configure mongo to use it
cd /etc/ssl/
openssl req -newkey rsa:2048 -new -x509 -days 365 -nodes -out mongodb-cert.crt -keyout mongodb-cert.key -subj "/C=US/ST=California/L=San Francisco/O=helloGov/OU=Engineering/CN=data.hellogov.org"
sudo sh -c "cat mongodb-cert.key mongodb-cert.crt > mongodb.pem"
scp mongodb.pem ops1:/tmp/mongodb.pem
cp /tmp/mongod.conf /etc/mongod.conf

#Test secure connections by creating application user
sudo service mongod start
mongo -u $DB_ADMIN_USER -p $DB_ADMIN_PASSWORD localhost/hellogov --authenticationDatabase admin --ssl --sslAllowInvalidHostnames --sslPEMKeyFile /etc/ssl/mongodb.pem --sslCAFile /etc/ssl/mongodb.pem --eval "db.createUser({user:'$DB_USER',pwd:'$DB_PASSWORD',roles:[{role:'readWrite',db:'hellogov'}]});"