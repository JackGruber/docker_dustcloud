# Docker containers for Xiaomi Mi Robot Vacuum dustcloud

Docker container for https://github.com/dgiese/dustcloud

## Getting Started
Creates four docker containers
- DB Server
- phpMyAdmin
- Dustcloud Proxy (Phyton files)
- Dustcloud backend (PHP files)



## Docker

### Build
```
docker build -t dustcloud .
```

### Run DB container
```
docker run --name dustcloud_mariadb -d -e MYSQL_ROOT_PASSWORD=rootdustcloudpw mariadb
```

### Run phpMyAdmin
```
docker run --name dustcloud_pma -d --link dustcloud_mariadb:db -p 8080:80 phpmyadmin/phpmyadmin
```

Login to phpMyAdmin an execute
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

### Run dustcloud
```
docker run --name dustcloud -d --link dustcloud_mariadb:mysqldb -p 80-81:80-81/tcp -p 8053:8053/udp dustcloud
```




### Start all
```
docker start dustcloud_mariadb dustcloud_pma dustcloud
```

### Stop all
```
docker stop dustcloud dustcloud_pma dustcloud_mariadb
```

## Commands in dustcloud
When starting a bash for the dustcloud_proxy container, all mirobo commands are available.
```
mirobo discover --handshake true
... 
```
