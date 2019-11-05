
mv BENGA_automatically_deploy_script/ deploy/
cd deploy/

. restore_databases.sh
. write_configs.sh
. install-blast.sh
. build-rabbitmq.sh
. build-benga.sh
. ~/deploy/build-nginx.sh
. ~/deploy/build-celery.sh

sudo systemctl start benga.service
sudo systemctl start celery.service
sudo systemctl restart nginx.service
