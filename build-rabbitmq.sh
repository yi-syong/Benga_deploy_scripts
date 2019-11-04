#!/usr/bin/bash
sudo apt install -y rabbitmq-server
sudo rabbitmqctl add_user celery TEjcuCTK5SctrAca
sudo rabbitmqctl add_vhost benga
sudo rabbitmqctl set_user_tags celery administrator
sudo rabbitmqctl set_permissions -p benga celery ".*" ".*" ".*"

export RABBITMQ_DEFAULT_USER=celery
export RABBITMQ_DEFAULT_PASS=TEjcuCTK5SctrAca
export RABBITMQ_DEFAULT_VHOST=benga