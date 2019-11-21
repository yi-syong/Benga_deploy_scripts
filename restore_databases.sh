#!/usr/bin/bash

#install postgres
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib postgresql-client-common

#download databases
mkdir databases
cd databases
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1GlOLzPMn2egRGCLH4MXxpMprCS2612Du' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1GlOLzPMn2egRGCLH4MXxpMprCS2612Du" -O dump_Vibrio_cholerae_15-05-2019_10_21_11 && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1iqeUx2HhNEYk97t9gozAoctufY3It9E7' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1iqeUx2HhNEYk97t9gozAoctufY3It9E7" -O Salmonella_enterica.sql  && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1kcVVIq9TWmbMUP4Vvyy9h595nVsDVuly' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1kcVVIq9TWmbMUP4Vvyy9h595nVsDVuly" -O Cronobacter_sakazakii.sql  && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1eca5NIIz84111BtHjqY2HkhfSvBcU2KE' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1eca5NIIz84111BtHjqY2HkhfSvBcU2KE" -O Listeria_monocytogenes.sql  && rm -rf /tmp/cookies.txt
mkdir Vibrio_cholerae
cd Vibrio_cholerae
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1zfYvtoXnZO60c1L36qnt0PKcv4fSzGNs' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1zfYvtoXnZO60c1L36qnt0PKcv4fSzGNs" -O track.bson  && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1zepTpVIs3OLfgOP5pxZQST4Vi0l8C6fX' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1zepTpVIs3OLfgOP5pxZQST4Vi0l8C6fX" -O track.metadata.json  && rm -rf /tmp/cookies.txt
cd ~/deploy/

#create a role named 'ubuntu'
sudo -u postgres psql -c "CREATE ROLE ubuntu WITH CREATEDB LOGIN PASSWORD '5qM5dU5jDf3gVHeP';"

#restore databases
createdb Vibrio_cholerae
createdb Salmonella_enterica
createdb Cronobacter_sakazakii
createdb Listeria_monocytogenes
psql Vibrio_cholerae < databases/dump_Vibrio_cholerae_15-05-2019_10_21_11
psql Salmonella_enterica < databases/Salmonella_enterica.sql
psql Cronobacter_sakazakii < databases/Cronobacter_sakazakii.sql
psql Listeria_monocytogenes < databases/Listeria_monocytogenes.sql

#install mongodb & restore database
sudo apt-get install -y mongodb
mongorestore -d Vibrio_cholerae databases/Vibrio_cholerae/