#!/bin/sh
echo "==================="
echo "Start ${VERSION}"
echo "==================="
CLOUDSERVERIP=${CLOUDSERVERIP:-130.83.47.181}
MYSQLSERVER=${MYSQLSERVER:-db}
MYSQLDB=${MYSQLDB:-dustcloud}
MYSQLUSER=${MYSQLUSER:-dustcloud}
MYSQLPW=${MYSQLPW:-dustcloudpw}
CMDSERVER_PORT=${CMDSERVER_PORT:-1121}
CMDSERVER=${CMDSERVER:-192.168.1.7}
TZ=${TZ:-Europe/Berlin}

#################################################
# IP adaptation to the docker internal IP for the commandserver
cp /dustcloud/server.py.master /dustcloud/server.py
sed -i -e "s/cmd_server.run(host=\"localhost\", port=cmd_server_port)/cmd_server.run(host=\"${CMD_SERVERIP}\", port=cmd_server_port)/g" /dustcloud/server.py
sed -i -e "s/{{MYSQLSERVER}}/${MYSQLSERVER}/g" $DUSTCLOUD/server.py
sed -i -e "s/{{MYSQLUSER}}/${MYSQLUSER}/g" $DUSTCLOUD/server.py
sed -i -e "s/{{MYSQLPW}}/${MYSQLPW}/g" $DUSTCLOUD/server.py
sed -i -e "s/{{MYSQLDB}}/${MYSQLDB}/g" $DUSTCLOUD/server.py
sed -i -e "s/{{CMDSERVER_PORT}}/${CMDSERVER_PORT}/g" $DUSTCLOUD/server.py
sed -i -e "s/{{CLOUDSERVERIP}}/${CLOUDSERVERIP}/g" $DUSTCLOUD/server.py

#################################################
# IP adaptaion to the docker external IP for the dustcloud commandserver
cp ${WWWDATA}/conf.sample.php ${WWWDATA}/conf.php
sed -i -e "s/{{MYSQLSERVER}}/${MYSQLSERVER}/g" $WWWDATA/conf.php
sed -i -e "s/{{MYSQLUSER}}/${MYSQLUSER}/g" $WWWDATA/conf.php
sed -i -e "s/{{MYSQLPW}}/${MYSQLPW}/g" $WWWDATA/conf.php
sed -i -e "s/{{MYSQLDB}}/${MYSQLDB}/g" $WWWDATA/conf.php
sed -i -e "s/{{CMDSERVER}}/${CMDSERVER}/g" $WWWDATA/conf.php
sed -i -e "s/{{CMDSERVER_PORT}}/${CMDSERVER_PORT}/g" $WWWDATA/conf.php

# Timezone
sed -i -e "s@{{TZ}}@${TZ}@g" /etc/php7/php.ini


# Start (ensure apache2 PID not left behind first) to stop auto start crashes if didn't shut down properly
echo "Clearing any old processes..."
rm -f /run/apache2/apache2.pid
rm -f /run/apache2/httpd.pid

echo "Starting apache..."
httpd -S
httpd -k start
echo "Starting Dustcloud..."
/dustcloud/server.sh
