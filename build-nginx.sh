#!/usr/bin/bash

sudo apt install -y nginx
sudo cp ~/deploy/configs/benga.conf /etc/nginx/sites-enabled/benga.conf