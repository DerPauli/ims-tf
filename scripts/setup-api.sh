#!/bin/bash

gh_token=$1
db_ip=$2


# install npm and dependecies for sofa / graphql
# TODO: maybe add swagger / openapi for documentation
sudo apt-get install -y gcc-c++ make git
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

# get repo
git clone https://${gh_token}@github.com/DerPauli/ims-api.git
cd ims-api

npm install
npm install pm2 -g

# exchange ip address
sed -i "s/\"host\": \"x.x.x.x\"/\"host\": \""${db_ip}"\"/g" config/config.json

# create database
npx sequelize db:create
npx sequelize db:migrate
npx sequelize db:seed:all

# start api
pm2 start src/pre.js --name api

# note certbot has to be started manually
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe -y
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update

sudo apt-get install -y certbot