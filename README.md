# Docker container for Xiaomi Mi Robot Vacuum dustcloud

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
docker build -t dustcloud_proxy .
docker build -t dustcloud_backend .
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

## Run dustcloud backend
```
docker run -d --name dustcloud_backend -p 81:80 --link dustcloud_mariadb:mysqldb --link dustcloud_proxy:cmdserver dustcloud_backend
```

### Run dustcloud Proxy
```
docker run --name dustcloud_proxy -d --link dustcloud_mariadb:mysqldb -p 80:80/tcp -p 8053:8053/udp -p 1121:1121/tcp dustcloud_proxy
```

### Commands in dustcloud_proxy
When starting a bash for the dustcloud_proxy container, all mirobo commands are available.
```
mirobo discover --handshake true
... 
```
