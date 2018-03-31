
# Docker containers for Xiaomi Mi Robot Vacuum dustcloud

Docker container for https://github.com/dgiese/dustcloud

## Getting Started
Creates three docker containers for Raspberry Pi and Linux x64
- DB Server
- phpMyAdmin
- Dustcloud


## Docker

**Build dustcloud**
```dustcloud_pi``` for Raspberry Pi
```dustcloud_x64``` for x64 Linux Platforms 

```
docker build -t dustcloud .
```

**create DB container**

Raspberry Pi
```
docker run --name dustcloud_mariadb -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=rootdustcloudpw jsurf/rpi-mariadb
```

x64 
```
docker run --name dustcloud_mariadb -d -e MYSQL_ROOT_PASSWORD=rootdustcloudpw mariadb
```

**create phpMyAdmin**

Raspberry Pi
```
still missing ...
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

**create dustcloud**

change the DUSTCLOUDIP=`192.168.1.129` to your IP from the docker host 
```
docker run --name dustcloud -d --link dustcloud_mariadb:mysqldb -p 80-81:80-81/tcp -p 8053:8053/udp -p 1121:1121/tcp -e DUSTCLOUDIP=192.168.1.129 dustcloud
```

 
 
## Running mirobo commands
```
docker exec -it dustcloud mirobo discover --handshake true
docker exec -it dustcloud mirobo --ip=192.168.X.X --token=XXX
...
```

