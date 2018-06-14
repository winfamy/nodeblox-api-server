#!/usr/bin/env bash
# Deploy script by Grady Phillips

echo 'Updating packages.'
apt-get -y update
apt-get -y upgrade

echo 'Installing package deps.'
apt-get -y -qq install nodejs npm git build-essential
git clone https://github.com/winfamy/nodeblox-api-server.git
cd nodeblox-api-server/

echo 'Installing NodeJS deps.'
npm install

echo 'Installing NVM.'
curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh -o install_nvm.sh
bash install_nvm.sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo 'Installing NodeJS v10.0.0.'
nvm install 10.0.0
nvm use 10.0.0
node -v

echo 'Installing systemctl service.'
cp nodeblox-api-server.service /etc/systemd/system/nodeblox-api-server.service
systemctl enable nodeblox-api-server

echo 'Starting up Nodeblox Server.'
systemctl start nodeblox-api-server

echo 'Cleaning up directory.'
rm -rf install_nvm.sh
