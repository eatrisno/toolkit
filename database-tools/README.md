# Databases toolkit
install

curl -sSk https://raw.githubusercontent.com/eatrisno/toolkit/master/database-tools/install.sh | bash

backup mongo with docker container

altomongo -t backup -f /backups/mongo -c docker_container_1 -z

altopostgres -t backup -f /backups/postgres -c docker_container_1 -u username -d database -z
