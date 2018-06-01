

# Docker containers for Xiaomi Mi Robot Vacuum dustcloud

Docker container for https://github.com/dgiese/dustcloud

## Getting Started
Creates three docker containers for Raspberry Pi and Linux x64
- DB Server
- phpMyAdmin
- Dustcloud 

The phpmyadmin and the DB server are optionale, you can use your existings instances.
You can youse the dustcloud from Docker Hub or build your own from the Repro. 

## Docker preparations

**Run DB container (optional)**

Raspberry Pi
```
docker run --name dustcloud_mariadb -d -e MYSQL_ROOT_PASSWORD=rootdustcloudpw \
-e TZ=$(cat /etc/timezone) jackgruber/mariadb
```

x64
```
docker run --name dustcloud_mariadb -d -e MYSQL_ROOT_PASSWORD=rootdustcloudpw mariadb
```

**Run phpMyAdmin container (optional)**

Raspberry Pi
```
docker run --name dustcloud_pma -d --link dustcloud_mariadb:db -p 8080:80 jackgruber/phpmyadmin
```

x64
```
docker run --name dustcloud_pma -d --link dustcloud_mariadb:db -p 8080:80 phpmyadmin/phpmyadmin
```

Login to phpMyAdmin ( http://YOURIP:8080 ) an execute
```
CREATE USER 'dustcloud'@'%' IDENTIFIED by 'dustcloudpw';
GRANT USAGE ON *.* TO 'dustcloud'@'%';
CREATE DATABASE IF NOT EXISTS `dustcloud`;
GRANT ALL PRIVILEGES ON `dustcloud`.* TO 'dustcloud'@'%';
```

Copy the content from the ```dustcloud.sql``` ans execute the SQL Querys in phpMyAdmin
```
https://github.com/dgiese/dustcloud/blob/master/dustcloud/dustcloud.sql
```

## Docker dustcloud

**Run dustcloud container**

change the CMDSERVER=`192.168.1.129` to your IP from the docker host

```
docker run --name dustcloud -d --link dustcloud_mariadb:db \
-p 80-81:80-81/tcp -p 8053:8053/udp -p 1121:1121/tcp \
-e CMDSERVER=192.168.1.129 \
-e TZ=$(cat /etc/timezone) \
-v /tmp/data:/dustcloud/data \
jackgruber/dustcloud:$(dpkg --print-architecture)
```

## Configuration
These options can be set via the environment variable -e flag:

- **CLOUDSERVERIP**: Your Dustcloud IP address (Default: 130.83.47.181, Values: \<IP addr>)
- **MYSQLSERVER**: MySQL Server address (Default: db, Values: \<IP addr> or \<DNS name>)
- **MYSQLDB**: MySQL database for dustcloud (Default: dustcloud, Values: \<string>)
- **MYSQLUSER**: User for MySQL database (Default: dustcloud, Values: \<string>)
- **MYSQLPW**: Password for MySQL database (Default: dustcloudpw, Values: \<string>)
- **CMDSERVER**: Command Server IP or DNS Name (Default: 192.168.1.7, Values: \<IP addr> or \<DNS name>)
- **CMDSERVER_PORT**: Port number for command server (Default: 1121, Values: \<1-65535>)
- **TZ**: Set Timezone (Default: Europe/Berlin, Values: \<[TZ](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)>)

## Build your own dustcloud image from Dockerfile

```
docker build -t dustcloud .
```
##  Add your Vacuum to dustcloud
Go to http://DUSTCLOUDIP:81 and add your Vacuum. DID and enckey can be found both in ```/mnt/default/device.conf``` on your robot

## Show server.py output
```
docker logs -f dustcloud
```

## Running python-miio (mirobo) commands
```
docker exec dustcloud mirobo discover --handshake true
docker exec dustcloud mirobo --ip=192.168.X.X --token=XXX
...
```

## Live map upload
1. Download [upload_maps.sh](https://github.com/dgiese/dustcloud/blob/master/dustcloud/upload_map.sh) 
2. Edit upload_map.sh and change DUSTCLOUD_SERVER=`192.168.xx.yy` to your dustcloud Server IP
3. Upload upload_map.sh to your Xiaomi
4. Start the upload with `watch -n5 ./upload_map.sh`

## Extract cleaning maps
1. Copy the robot.db from you Xiaomi ```/mnt/data/rockrobo/robot.db``` to ```/tmp/data```
2. Run ```docker exec dustcloud python3 /dustcloud/map_extractor.py -f /dustcloud/data/robot.db -o /dustcloud/data -c```
3. The extracted maps are now in ```/tmp/data``` and can now be opened with FasteStone Image Viewer or IrfanView

## Links
Raspberry Pi phpMyAdmin https://github.com/JackGruber/docker_rpi-phpmyadmin

Raspberry Pi MariaDB https://github.com/JSurf/docker-rpi-mariadb 

python-miio Commands https://python-miio.readthedocs.io/en/latest/vacuum.html


## Changelog

### 01.06.2018
- Add composer support 

### 12.05.2018
- Change to ENV var configuration settings

### 07.04.2018
- Add timezone to php.ini

### 02.04.2018
- Changed to alpine as base image, so there is only one docker file for Raspberry Pi and x64. 
- Also the size has been reduced from 592MB to 180MB for the docker image
