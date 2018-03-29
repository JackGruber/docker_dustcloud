FROM php:7.0-apache

RUN apt-get update && apt-get install -y \
    authbind \
    curl \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /var/www/html/

RUN docker-php-ext-install mysqli

# get python miio components
#RUN pip3 install \
#    bottle \
#    pillow \
#    pymysql \
#    python-miio

# get dustcloud
RUN echo "<?php phpinfo(); ?>" > info.php \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/fns.php --output fns.php \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/index.php --output index.php \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/newdevice.php --output newdevice.php \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/show.php --output show.php \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/showcmdlog.php --output showcmdlog.php \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/showlog.php --output showlog.php \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/style.css --output style.css \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/config.php.dist --output config.php

# configuration for MySQL Server and public dustcloud IP
# mysqldb = docker network link name
ENV MYSQLIP mysqldb
ENV MYSQLDB dustcloud
ENV MYSQLUSER dustcloud
ENV MYSQLPW dustcloudpw
ENV CMD_SERVER cmdserver

RUN sed -i -e "s/const DB_HOST = 'localhost';/const DB_HOST = '${MYSQLIP}';/g" config.php \
    && sed -i -e "s/const DB_USER = 'user123';/const DB_USER = '${MYSQLUSER}';/g" config.php \
    && sed -i -e "s/const DB_PASS = '';/const DB_PASS = '${MYSQLPW}';/g" config.php \
    && sed -i -e "s/const DB_NAME = 'dustcloud';/const DB_NAME = '${MYSQLDB}';/g" config.php \
    && sed -i -e "s/const CMD_SERVER = 'http:\/\/localhost:1121\/';/const CMD_SERVER = 'http:\/\/${CMD_SERVER}:1121\/';/g" config.php
