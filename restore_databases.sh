#!/usr/bin/bash

#install postgres
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib postgresql-client-common

#download databases
mkdir databases
cd databases

wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1mYZQ4wqssq740nXg_7WgpuOc4XX3xDQx' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1mYZQ4wqssq740nXg_7WgpuOc4XX3xDQx" -O Campylobacter_coli_jejuni.sql && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1q6AS0OW1x4FSy7IGfXp9VhBu5bGzS68Z' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1q6AS0OW1x4FSy7IGfXp9VhBu5bGzS68Z" -O Cronobacter_sakazakii.sql && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1GlOLzPMn2egRGCLH4MXxpMprCS2612Du' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1GlOLzPMn2egRGCLH4MXxpMprCS2612Du" -O dump_Vibrio_cholerae_15-05-2019_10_21_11 && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1Y7EFkcPk4vNLpvVVeNQJuskZKyilXLjg' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1Y7EFkcPk4vNLpvVVeNQJuskZKyilXLjg" -O Ecoli_Shigella.sql && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1gUkQAZ9kt1X-VOTE4ylOIJrg__9829CW' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1gUkQAZ9kt1X-VOTE4ylOIJrg__9829CW" -O Listeria_monocytogenes.sql  && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1JNoAzC36cRYT46l4Y-4PtpYjpcwlThtf' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1JNoAzC36cRYT46l4Y-4PtpYjpcwlThtf" -O Mycobacterium_tuberculosis.sql  && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1K3VikL0ixL9g9dvTUZCMyg_EVq4cLMil' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1K3VikL0ixL9g9dvTUZCMyg_EVq4cLMil" -O Neisseria_meningitidis.sql  && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=17GmSVRk2BJhXRc20T1R5csVXqwCM4PyZ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=17GmSVRk2BJhXRc20T1R5csVXqwCM4PyZ" -O Salmonella_enterica.sql  && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1AZhKE_mUzuemgb7-JIgnkfzPuFplk2PQ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1AZhKE_mUzuemgb7-JIgnkfzPuFplk2PQ" -O Vibrio_parahaemolyticus.sql  && rm -rf /tmp/cookies.txt

mkdir Vibrio_cholerae
cd Vibrio_cholerae
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1zfYvtoXnZO60c1L36qnt0PKcv4fSzGNs' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1zfYvtoXnZO60c1L36qnt0PKcv4fSzGNs" -O track.bson  && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1zepTpVIs3OLfgOP5pxZQST4Vi0l8C6fX' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1zepTpVIs3OLfgOP5pxZQST4Vi0l8C6fX" -O track.metadata.json  && rm -rf /tmp/cookies.txt
cd ~/deploy/

#create a role named 'ubuntu'
sudo -u postgres psql -c "CREATE ROLE ${USER} WITH CREATEDB LOGIN PASSWORD '5qM5dU5jDf3gVHeP';"

#restore databases
createdb Campylobacter_coli/jejuni
createdb Cronobacter_sakazakii
createdb Ecoli/Shigella
createdb Listeria_monocytogenes
createdb Mycobacterium_tuberculosis
createdb Neisseria_meningitidis
createdb Salmonella_enterica
createdb Vibrio_cholerae
createdb Vibrio_parahaemolyticus

psql Campylobacter_coli/jejuni < databases/Campylobacter_coli_jejuni.sql
psql Cronobacter_sakazakii < databases/Cronobacter_sakazakii.sql
psql Ecoli/Shigella < databases/Ecoli_Shigella.sql
psql Listeria_monocytogenes < databases/Listeria_monocytogenes.sql
psql Mycobacterium_tuberculosis < databases/Mycobacterium_tuberculosis.sql
psql Neisseria_meningitidis < databases/Neisseria_meningitidis.sql
psql Salmonella_enterica < databases/Salmonella_enterica.sql
psql Vibrio_cholerae < databases/dump_Vibrio_cholerae_15-05-2019_10_21_11
psql Vibrio_parahaemolyticus < databases/Vibrio_parahaemolyticus.sql


#install mongodb & restore database
sudo apt-get install -y mongodb
mongorestore -d Vibrio_cholerae databases/Vibrio_cholerae/