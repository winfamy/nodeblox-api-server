#!/usr/bin/env bash
# Deploy script by Grady Phillips

echo 'Updating packages.'
apt-get update >/dev/null
apt-get upgrade -y >/dev/null

echo 'Installing package deps.'
apt-get install nodejs npm git build-essential >/dev/null
git clone https://github.com/winfamy/nodeblox-api-server.git>/dev/null
cd nodeblox-api-server/

echo 'Installing NodeJS deps.'
npm install>/dev/null

echo 'Installing NVM.'
curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh -o install_nvm.sh>/dev/null
bash install_nvm.sh>/dev/null
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo 'Installing NodeJS v10.0.0.'
nvm install 10.0.0 >/dev/null
nvm use 10.0.0 >/dev/null
node -v

echo 'Installing systemctl service.'
cp nodeblox-api-server.service /etc/systemd/system/nodeblox-api-server.service
systemctl enable nodeblox-api-server>/dev/null

echo 'Starting up Nodeblox Server.'
systemctl start nodeblox-api-server>/dev/null

echo 'Cleaning up directory.'
rm -rf install_nvm.sh
