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

#benga_setting.py
export SECRET_KEY=$(python -c 'import random, string; result = "".join([random.SystemRandom().choice("{}{}{}".format(string.ascii_letters, string.digits, string.punctuation)) for i in range(50)]); print(result)')
export DQ='"""'
export AP="'"

echo $SECRET_KEY | sed s/$AP/@/g

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
        ${AP}USER${AP}: ${AP}ubuntu${AP},
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
rm benga/settings.py
cp ~/deploy/configs/settings.py benga/settings.py

#build frontend

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
export NVM_DIR="$HOME.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
#. venv/bin/activate
nvm install v10.13.0
sudo apt install -y npm
npm install
export NODE_OPTIONS=--max_old_space_size=4096
npm run build
npm run build-nonrelease

#createdb benga
python manage.py check
python manage.py makemigrations
python manage.py migrate

sudo mkdir -p /var/www/benga/cgMLST/
sudo chown ubuntu -R /var/www/benga/cgMLST/
python manage.py collectstatic --noinput

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
