

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
docker run --name dustcloud_mariadb -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=rootdustcloudpw jsurf/rpi-mariadb
```

x64
```
docker run --name dustcloud_mariadb -d -e MYSQL_ROOT_PASSWORD=rootdustcloudpw mariadb
```

**Run phpMyAdmin container (optional)**

Raspberry Pi
```
docker run --name dustcloud_pma -d --link dustcloud_mariadb:db -p 8080:80 jackgruber/phpmyadmin_rpi
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

change the DUSTCLOUDIP=`192.168.1.129` to your IP from the docker host

Raspberry Pi
```
docker run --name dustcloud -d --link dustcloud_mariadb:mysqldb \
-p 80-81:80-81/tcp -p 8053:8053/udp -p 1121:1121/tcp \
-e DUSTCLOUDIP=192.168.1.129 \
-v /tmp/data:/dustcloud/data \
jackgruber/dustcloud_pi
```

x64
```
docker run --name dustcloud -d --link dustcloud_mariadb:mysqldb \
-p 80-81:80-81/tcp -p 8053:8053/udp -p 1121:1121/tcp \
-e DUSTCLOUDIP=192.168.1.129 \
-v /tmp/data:/dustcloud/data \
jackgruber/dustcloud
```

## Build your own dustcloud image from Dockerfile

```
docker build -t dustcloud .
```


## Show server.py output
```
docker logs dustcloud
```

## Running python-miio (mirobo) commands
```
docker exec dustcloud mirobo discover --handshake true
docker exec dustcloud mirobo --ip=192.168.X.X --token=XXX
...
```

## Extract cleaning maps
1. Copy the robot.db from you Xiaomi ```/mnt/data/rockrobo/robot.db``` to ```/tmp/data```
2. Run ```docker exec dustcloud python3 /dustcloud/map_extractor.py -f /dustcloud/data/robot.db -o /dustcloud/data -c```
3. The extracted maps are now in ```/tmp/data``` and can now be opened with FasteStone Image Viewer or IrfanView

## Links
Raspberry Pi phpMyAdmin https://github.com/JackGruber/docker_rpi-phpmyadmin

Raspberry Pi MariaDB https://github.com/JSurf/docker-rpi-mariadb 

python-miio Commands https://python-miio.readthedocs.io/en/latest/vacuum.html


## Changelog

### 02.04.2018
- Changed to alpine as base image, so there is only one docker file for Raspberry Pi and x64. 
- Also the size has been reduced from 592MB to 180MB for the docker image


