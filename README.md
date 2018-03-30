# Docker containers for Xiaomi Mi Robot Vacuum dustcloud

Docker container for https://github.com/dgiese/dustcloud

## Getting Started
Creates three docker containers for x86
- DB Server
- phpMyAdmin
- Dustcloud


## Docker

**Build dustcloud**
```
docker build -t dustcloud .
```

**Run DB container**
```
docker run --name dustcloud_mariadb -d -e MYSQL_ROOT_PASSWORD=rootdustcloudpw mariadb
```

**Run phpMyAdmin**
```
docker run --name dustcloud_pma -d --link dustcloud_mariadb:db -p 8080:80 phpmyadmin/phpmyadmin
```

Login to phpMyAdmin ( http://IPADRESS:8080 ) an execute
```
CREATE USER 'dustcloud'@'%' IDENTIFIED by 'dustcloudpw';
GRANT USAGE ON *.* TO 'dustcloud'@'%';
CREATE DATABASE IF NOT EXISTS `dustcloud`;
GRANT ALL PRIVILEGES ON `dustcloud`.* TO 'dustcloud'@'%';
```

execute SQL Query file for database structure creation
```
https://github.com/dgiese/dustcloud/blob/master/dustcloud/dustcloud.sql
```

**Run dustcloud persistent**
change the DUSTCLOUDIP=`192.168.1.129` to your IP from the docker host 
```
docker run --name dustcloud -d --link dustcloud_mariadb:mysqldb -p 80-81:80-81/tcp -p 8053:8053/udp -p 1121:1121/tcp -e DUSTCLOUDIP=192.168.1.129 dustcloud
```
or
*Rund dustcloud interactive*
```
docker run --rm -it --link dustcloud_mariadb:mysqldb -p 80-81:80-81/tcp -p 8053:8053/udp -p 1121:1121/tcp -e DUSTCLOUDIP=192.168.1.129 dustcloud 
```
 
**To start / stop all docker conatner at once**
```
docker start dustcloud_mariadb dustcloud_pma dustcloud
docker stop dustcloud dustcloud_pma dustcloud_mariadb
```
 
 
 
## Running mirobo commands
```
docker exec -it dustcloud mirobo discover --handshake true
docker exec -it dustcloud mirobo --ip=192.168.X.X --token=XXX
...
```
