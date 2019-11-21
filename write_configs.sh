#!/bin/bash

mkdir configs

#nginx config
ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo "upstream django {
    server unix:///run/uwsgi/benga.sock;
}

server {
    listen 80;
    server_name ${ip};
    charset utf-8;

    root /var/www/benga/;
    client_max_body_size 10M;

    #error_page 404 403 /custom_404.html;
    #location = /custom_404.html {
    #    root /usr/share/nginx/html;
    #    internal;
    #}

    location /cgMLST/ {
        uwsgi_pass django;
        include uwsgi_params;
        uwsgi_ignore_client_abort on;
        uwsgi_read_timeout 3000;
        uwsgi_send_timeout 3000;
    }
    
    location /cgMLST/static/ {
        alias /var/www/benga/cgMLST/static/;
    }

    location /cgMLST/media/ {
        alias /var/www/benga/cgMLST/media/;
    }

    #location ~* \.(jpg|jpeg|png|css|js)$ {
    #    expires 365d;
    #}
}" > ~/deploy/configs/benga.conf

#uwsgi config
echo "[Unit]
Description=Benga server by uWSGI
After=syslog.target

[Service]
ExecStart=/home/${USER}/Benga/venv/bin/uwsgi --ini /etc/uwsgi/vassals/uwsgi.ini
Restart=always
KillSignal=SIGQUIT
Type=notify
StandardOutput=syslog
StandardError=syslog
NotifyAccess=all

[Install]
WantedBy=multi-user.target" > ~/deploy/configs/benga.service


echo "[uwsgi]
module = benga.wsgi:application
master = true
processes = 2

enable-threads = true
threads = 4
thunder-lock = true
virtualenv = venv
#listen = 500

chdir = /home/${USER}/Benga/
logto = /var/log/uwsgi/benga.log

socket = /run/uwsgi/benga.sock
chmod-socket = 666
uid = www-data
gid = www-data
vacuum = true

buffer-size = 655350
harakiri = 240 
http-timeout = 300
socket-timeout = 300
worker-reload-mercy = 240 
reload-mercy = 240 
mule-reload-mercy = 240" > ~/deploy/configs/uwsgi.ini

#celery config
echo "CELERY_APP='benga'
CELERY_BIN='/home/${USER}/Benga/venv/bin/celery'
CELERYD_NODES=2
CELERYD_CHDIR='/home/${USER}/Benga'
CELERYD_OPTS='-c 8'
CELERYD_USER='www-data'
CELERYD_GROUP='www-data'
CELERYD_PID_FILE='/var/run/celery/worker.pid'
CELERYD_LOG_FILE='/var/log/celery/worker.log'
CELERYD_LOG_LEVEL='INFO'" > ~/deploy/configs/celeryd

export W_CELERY_BIN='${CELERY_BIN}'
export W_CELERYD_NODES='${CELERYD_NODES}'
export W_CELERY_APP='${CELERY_APP}'
export W_CELERYD_PID_FILE='${CELERYD_PID_FILE}'
export W_CELERYD_LOG_FILE='${CELERYD_LOG_FILE}'
export W_CELERYD_LOG_LEVEL='${CELERYD_LOG_LEVEL}'
export W_CELERYD_OPTS='${CELERYD_OPTS}'
export BS='\'

echo "[Unit]
Description=Celery Service
After=network.target

[Service]
Type=forking
User=www-data
Group=www-data
EnvironmentFile=/etc/default/celeryd
WorkingDirectory=/home/${USER}/Benga

ExecStart=/bin/sh -c '${W_CELERY_BIN} multi start ${W_CELERYD_NODES} ${BS}
  -A ${W_CELERY_APP} --pidfile=${W_CELERYD_PID_FILE} ${BS}
  --logfile=${W_CELERYD_LOG_FILE} --loglevel=${W_CELERYD_LOG_LEVEL} ${CELERYD_OPTS}'

ExecStop=/bin/sh -c '${W_CELERY_BIN} multi stopwait ${W_CELERYD_NODES} ${BS}
  -A ${W_CELERY_APP} --pidfile=${W_CELERYD_PID_FILE}'

ExecReload=/bin/sh -c '${W_CELERY_BIN} multi restart ${W_CELERYD_NODES} ${BS}
  -A ${W_CELERY_APP} --pidfile=${W_CELERYD_PID_FILE} ${BS}
  --logfile=${W_CELERYD_LOG_FILE} --loglevel=${W_CELERYD_LOG_LEVEL} ${W_CELERYD_OPTS}'

[Install]
WantedBy=multi-user.target" > ~/deploy/configs/celery.service