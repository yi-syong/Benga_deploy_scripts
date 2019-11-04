#!/usr/bin/bash

sudo cp ~/deploy/configs/celeryd /etc/default/celeryd
sudo cp ~/deploy/configs/celery.service /etc/systemd/system/celery.service
sudo mkdir /var/run/celery/
sudo mkdir /var/log/celery/
sudo touch /var/run/celery/worker.pid
sudo touch /var/log/celery/worker.log
sudo chmod 755 /var/log/celery/worker.log
sudo chown www-data /var/log/celery/worker.log
sudo chmod 755 /var/run/celery/
sudo chmod 644 /var/run/celery/worker.pid
sudo chown -R www-data:www-data /var/run/celery/