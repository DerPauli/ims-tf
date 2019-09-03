#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl git apache2 nginx

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

git clone https://github.com/DerPauli/ims-ui.git
cd ims-ui/ims-ui


sudo systemctl restart nginx


# disable google analytics promt
export NG_CLI_ANALYTICS=ci

npm install

npm run build
npm install -g serve


serve -s build -l 80 &