# Docker containers for Xiaomi Mi Robot Vacuum dustcloud

Docker container for https://github.com/dgiese/dustcloud

## Getting Started
Creates three docker containers for x86
- DB Server
- phpMyAdmin
- Dustcloud


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

### Run dustcloud persistent
```
docker run --name dustcloud -d --link dustcloud_mariadb:mysqldb -p 80-81:80-81/tcp -p 8053:8053/udp dustcloud
```

### Rund dustcloud interactive
```
docker run --rm -it -p 80-81:80-81/tcp -p 8053:8053/udp --link dustcloud_mariadb:mysqldb dustcloud 
```












### Start all
```
docker start dustcloud_mariadb dustcloud_pma dustcloud
```

### Stop all
```
docker stop dustcloud dustcloud_pma dustcloud_mariadb
```



## Running mirobo commands
```
docker exec -it dustcloud mirobo discover --handshake true
docker exec -it dustcloud mirobo --ip=192.168.X.X --token=XXX
...
```
