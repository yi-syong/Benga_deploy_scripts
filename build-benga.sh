#!/usr/bin/bash

#backend

sudo apt install -y git python3-pip virtualenv
cd ~
git clone https://github.com/openCDCTW/Benga.git
cd Benga/
git checkout develop
virtualenv venv -p python3
. venv/bin/activate
pip install -r requirements.txt --upgrade
createdb benga
rm benga/settings.py
cp ~/deploy/configs/settings.py benga/settings.py

#build frontend

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
export NVM_DIR="$HOME.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
#. venv/bin/activate
nvm install v10.13.0
npm install
export NODE_OPTIONS=--max_old_space_size=4096
npm run build
npm run build-nonrelease

#createdb benga
python manage.py check
python manage.py makemigrations
python manage.py migrate

sudo mkdir -p /var/www/benga/cgMLST/
sudo chown ubuntu /var/www/benga/cgMLST/
python manage.py collectstatic

sudo chown -R www-data /var/www/benga
sudo chmod -R 755 /var/www/benga

#build uwsgi
sudo mkdir /var/log/uwsgi/
sudo touch /var/log/uwsgi/benga.log
sudo chown -R www-data /var/log/uwsgi/
sudo mkdir /run/uwsgi/
sudo touch /run/uwsgi/benga.sock
sudo chown -R www-data /run/uwsgi/

sudo mkdir -p /etc/uwsgi/vassals/
sudo cp ~/deploy/configs/uwsgi.ini /etc/uwsgi/vassals/uwsgi.ini
sudo cp ~/deploy/configs/benga.service /etc/systemd/system/benga.service