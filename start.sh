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
COUNTRYSERVER=${COUNTRYSERVER:-ott.io.mi.com}
TZ=${TZ:-Europe/Berlin}
DEBUG=${DEBUG:-false}


echo CLOUDSERVERIP=${CLOUDSERVERIP}
echo MYSQLSERVER=${MYSQLSERVER}
echo MYSQLDB=${MYSQLDB}
echo MYSQLUSER=${MYSQLUSER}
echo MYSQLPW=*****
echo CMDSERVER_PORT=${CMDSERVER_PORT}
echo CMDSERVER=${CMDSERVER}
echo COUNTRYSERVER=${COUNTRYSERVER}
echo TZ=${TZ}
echo DEBUG=${DEBUG}
echo "==================="


#################################################
# IP adaptation to the docker internal IP for the commandserver
cp $DUSTCLOUD/server.py.master $DUSTCLOUD/server.py
sed -i -e "s/cmd_server.run(host=\"localhost\", port=cmd_server_port)/cmd_server.run(host=\"${CMD_SERVERIP}\", port=cmd_server_port)/g" $DUSTCLOUD/server.py
sed -i -e "s/{{CLOUD_SERVER_ADDRESS}}/${COUNTRYSERVER}/g" $DUSTCLOUD/server.py

#################################################
# dustcloud config adaptaion
cp ${DUSTCLOUD}/config.master.ini ${DUSTCLOUD}/config.ini
sed -i -e "s/{{CLOUDSERVERIP}}/${CLOUDSERVERIP}/g" $DUSTCLOUD/config.ini
sed -i -e "s/{{MYSQLSERVER}}/${MYSQLSERVER}/g" $DUSTCLOUD/config.ini
sed -i -e "s/{{MYSQLUSER}}/${MYSQLUSER}/g" $DUSTCLOUD/config.ini
sed -i -e "s/{{MYSQLPW}}/${MYSQLPW}/g" $DUSTCLOUD/config.ini
sed -i -e "s/{{MYSQLDB}}/${MYSQLDB}/g" $DUSTCLOUD/config.ini
sed -i -e "s/{{CMDSERVER}}/${CMDSERVER}/g" $DUSTCLOUD/config.ini
sed -i -e "s/{{CMDSERVER_PORT}}/${CMDSERVER_PORT}/g" $DUSTCLOUD/config.ini
sed -i -e "s/{{DEBUG}}/${DEBUG}/g" $DUSTCLOUD/config.ini


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
/opt/dustcloud/server.sh
