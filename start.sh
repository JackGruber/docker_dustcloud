#!/bin/sh

unset MYSQLPW
unset MYSQLDB_ENV_MYSQL_ROOT_PASSWORD

#################################################
# IP adaptation to the docker internal IP for the commandserver
CMD_SERVERIP=$(ping -c 1 $HOSTNAME | grep -i ping | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
cp /dustcloud/server.py.master /dustcloud/server.py
sed -i -e "s/cmd_server.run(host=\"localhost\", port=cmd_server_port)/cmd_server.run(host=\"${CMD_SERVERIP}\", port=cmd_server_port)/g" /dustcloud/server.py


#################################################
# IP adaptaion to the docker external IP for the dustcloud commandserver
cp ${WWWDATA}/config_master.php ${WWWDATA}/config.php
sed -i -e "s/const CMD_SERVER = 'http:\/\/localhost:1121\/';/const CMD_SERVER = \"http:\/\/$DUSTCLOUDIP:1121\/\";/g" ${WWWDATA}/config.php



# Start (ensure apache2 PID not left behind first) to stop auto start crashes if didn't shut down properly
echo "Clearing any old processes..."
rm -f /run/apache2/apache2.pid
rm -f /run/apache2/httpd.pid

echo "Starting apache..."
httpd -S
httpd -k start
echo "Starting Dustcloud..."
/dustcloud/server.sh
