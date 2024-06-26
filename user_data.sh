#!/bin/bash
sudo yum update -y
sudo yum install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
mongo --eval 'db.createUser({user:"admin",pwd:"password123",roles:[{role:"userAdminAnyDatabase",db:"admin"}]})'
sudo sed -i '/#security:/a\security:\n  authorization: "enabled"' /etc/mongod.conf
sudo systemctl restart mongod
