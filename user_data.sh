#!/bin/bash

# Update the system packages
sudo yum update -y

# Install MongoDB (adjust version as needed)
sudo tee /etc/yum.repos.d/mongodb-org-4.4.repo <<EOF
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOF

sudo yum install -y mongodb-org-4.4 mongodb-org-server-4.4 mongodb-org-shell-4.4 mongodb-org-mongos-4.4 mongodb-org-tools-4.4

# Start MongoDB service
sudo systemctl start mongod

# Enable MongoDB service to start on boot
sudo systemctl enable mongod

# Create an admin user in MongoDB
mongo --eval 'db.createUser({user:"admin",pwd:"password123",roles:[{role:"userAdminAnyDatabase",db:"admin"}]})'

# Enable authentication in MongoDB configuration
sudo sed -i '/#security:/a\security:\n  authorization: "enabled"' /etc/mongod.conf

# Restart MongoDB service to apply changes
sudo systemctl restart mongod
