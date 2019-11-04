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
ExecStart=/home/ubuntu/Benga/venv/bin/uwsgi --ini /etc/uwsgi/vassals/uwsgi.ini
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

chdir = /home/ubuntu/Benga/
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
CELERY_BIN='/home/ubuntu/Benga/venv/bin/celery'
CELERYD_NODES=2
CELERYD_CHDIR='/home/ubuntu/Benga'
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
WorkingDirectory=/home/ubuntu/Benga

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


#benga_setting.py
export SECRET_KEY=$(python -c 'import random, string; result = "".join([random.SystemRandom().choice("{}{}{}".format(string.ascii_letters, string.digits, string.punctuation)) for i in range(50)]); print(result)')
export DQ='"""'
export AP="'"

echo "${DQ}
Django settings for benga project.

Generated by 'django-admin startproject' using Django 2.0.7.

For more information on this file, see
https://docs.djangoproject.com/en/2.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/2.0/ref/settings/
${DQ}

import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/2.0/howto/deployment/checklist/

# CELERY
CELERY_BROKER_URL = ${AP}amqp://celery:TEjcuCTK5SctrAca@127.0.0.1:5672/benga${AP}
CELERY_ACCEPT_CONTENT = [${AP}json${AP}]
CELERY_RESULT_BACKEND = ${AP}django-db${AP}
CELERY_TASK_SERIALIZER = ${AP}json${AP}
CELERYD_MAX_TASKS_PER_CHILD = 100

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = ${AP}${SECRET_KEY}${AP}

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

ALLOWED_HOSTS = [${AP}*${AP}]


# Application definition

INSTALLED_APPS = [
    ${AP}django.contrib.admin${AP},
    ${AP}django.contrib.auth${AP},
    ${AP}django.contrib.contenttypes${AP},
    ${AP}django.contrib.sessions${AP},
    ${AP}django.contrib.messages${AP},
    ${AP}django.contrib.staticfiles${AP},
    ${AP}rest_framework${AP},
    ${AP}django_celery_results${AP},
    ${AP}profiling.apps.ProfilingConfig${AP},
    ${AP}dendrogram.apps.DendrogramConfig${AP},
    ${AP}frontend.apps.FrontendConfig${AP},
    ${AP}tracking.apps.TrackingConfig${AP},
]

MIDDLEWARE = [
    ${AP}django.middleware.security.SecurityMiddleware${AP},
    ${AP}django.contrib.sessions.middleware.SessionMiddleware${AP},
    ${AP}django.middleware.common.CommonMiddleware${AP},
    ${AP}django.middleware.csrf.CsrfViewMiddleware${AP},
    ${AP}django.contrib.auth.middleware.AuthenticationMiddleware${AP},
    ${AP}django.contrib.messages.middleware.MessageMiddleware${AP},
    ${AP}django.middleware.clickjacking.XFrameOptionsMiddleware${AP},
]

ROOT_URLCONF = ${AP}benga.urls${AP}

TEMPLATES = [
    {
        ${AP}BACKEND${AP}: ${AP}django.template.backends.django.DjangoTemplates${AP},
        ${AP}DIRS${AP}: [],
        ${AP}APP_DIRS${AP}: True,
        ${AP}OPTIONS${AP}: {
            ${AP}context_processors${AP}: [
                ${AP}django.template.context_processors.debug${AP},
                ${AP}django.template.context_processors.request${AP},
                ${AP}django.contrib.auth.context_processors.auth${AP},
                ${AP}django.contrib.messages.context_processors.messages${AP},
            ],
        },
    },
]

WSGI_APPLICATION = ${AP}benga.wsgi.application${AP}

# Database
# https://docs.djangoproject.com/en/2.0/ref/settings/#databases

DATABASES = {
    ${AP}default${AP}: {
        ${AP}ENGINE${AP}: ${AP}django.db.backends.postgresql_psycopg2${AP},
        ${AP}NAME${AP}: ${AP}benga${AP},
        ${AP}USER${AP}: ${AP}centrallab${AP},
        ${AP}PASSWORD${AP}: ${AP}5qM5dU5jDf3gVHeP${AP},
        ${AP}HOST${AP}: ${AP}127.0.0.1${AP},
        ${AP}PORT${AP}: 5432
    }
}


NOSQLS = {
    ${AP}mongodb${AP}: {
        ${AP}HOST${AP}: ${AP}127.0.0.1${AP},
        ${AP}PORT${AP}: 27017
    }
}


# Password validation
# https://docs.djangoproject.com/en/2.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        ${AP}NAME${AP}: ${AP}django.contrib.auth.password_validation.UserAttributeSimilarityValidator${AP},
    },
    {
        ${AP}NAME${AP}: ${AP}django.contrib.auth.password_validation.MinimumLengthValidator${AP},
    },
    {
        ${AP}NAME${AP}: ${AP}django.contrib.auth.password_validation.CommonPasswordValidator${AP},
    },
    {
        ${AP}NAME${AP}: ${AP}django.contrib.auth.password_validation.NumericPasswordValidator${AP},
    },
]


# Internationalization
# https://docs.djangoproject.com/en/2.0/topics/i18n/

LANGUAGE_CODE = ${AP}en-us${AP}

TIME_ZONE = ${AP}Asia/Taipei${AP}

CELERY_TIMEZONE = TIME_ZONE

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/2.0/howto/static-files/

STATIC_URL = ${AP}static/${AP}
STATIC_ROOT = ${AP}/var/www/benga/cgMLST/static/${AP}

MEDIA_URL = ${AP}media/${AP}
MEDIA_ROOT = ${AP}/var/www/benga/cgMLST/media/${AP}" > ~/deploy/configs/settings.py
