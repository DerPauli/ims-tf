#!/bin/bash

gh_token=$1
db_ip=$2

# install npm and dependecies for sofa / graphql
# TODO: maybe add swagger / openapi for documentation
sudo apt-get install -y gcc-c++ make git
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

# get repo
git clone https://${gh_token}@github.com/DerPauli/ims-auth.git
cd ims-auth

sed -i "s/host=x.x.x.x/host=${db_ip}/g" .env

npm install
npm install pm2 -g

# start api
pm2 start src/server.js --name auth