FROM debian

RUN apt-get update && apt-get install -y \
    apache2 \
    authbind \
    curl \
    git \
    php \
    php-mysql \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# get python miio components
RUN pip3 install \
    bottle \
    pillow \
    pymysql \
    python-miio

# allow www-data to bind port 80 with authbind
RUN touch /etc/authbind/byport/80 \
    && chown www-data /etc/authbind/byport/80 \
    && chmod 755 /etc/authbind/byport/80

# Dustcloud Data
RUN git clone --depth 1 https://github.com/dgiese/dustcloud.git /gitdata \
    && cp /gitdata/dustcloud/www/* /var/www/html/ \
    && mv /var/www/html/config.php.dist /var/www/html/config_master.php \
    && mkdir /dustcloud \
    && cp /gitdata/dustcloud/server.py /dustcloud/server.py.master \
    && cp /gitdata/dustcloud/build_map.py /dustcloud/build_map.py \
    && echo 'su -c "authbind python3 /dustcloud/server.py" -s /bin/bash - www-data' > /dustcloud/server.sh \
    && chmod +x /dustcloud/server.sh \
    && echo "<?php phpinfo(); ?>" > /var/www/html/info.php \
    && rm -rf /gitdata \
    && rm /var/www/html/index.html

###########################################################################
# User configuration for MySQL Server and public dustcloud IP
# mysqldb = docker network link name
ENV MYSQLIP mysqldb
ENV MYSQLDB dustcloud
ENV MYSQLUSER dustcloud
ENV MYSQLPW dustcloudpw
ENV CLOUDSERVERIP 130.83.47.181
###########################################################################

RUN sed -i -e "s/pymysql.connect(\"localhost\", \"dustcloud\", \"\", \"dustcloud\")/pymysql.connect(\"${MYSQLIP}\",\"${MYSQLUSER}\",\"${MYSQLPW}\",\"${MYSQLDB}\")/g" /dustcloud/server.py.master \
    && sed -i -e "s/my_cloudserver_ip = \"10.0.0.1\"/my_cloudserver_ip = \"${CLOUDSERVERIP}\"/g" /dustcloud/server.py.master


# Apache settings
ENV APACHE_PID_FILE ${APACHE_RUN_DIR}/apache2.pid
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2

WORKDIR /var/www/html

# Customization for dustcloud database connection
RUN sed -i -e "s/const DB_HOST = 'localhost';/const DB_HOST = '${MYSQLIP}';/g" config_master.php \
    && sed -i -e "s/const DB_USER = 'user123';/const DB_USER = '${MYSQLUSER}';/g" config_master.php \
    && sed -i -e "s/const DB_PASS = '';/const DB_PASS = '${MYSQLPW}';/g" config_master.php \
    && sed -i -e "s/const DB_NAME = 'dustcloud';/const DB_NAME = '${MYSQLDB}';/g" config_master.php

# Customization for PHP and Apache
ENV APACHE_PORT 81
RUN sed -i -e "s/;error_log = php_errors.log/error_log = php_errors.log/g" /etc/php/7.0/apache2/php.ini \
    && sed -i -e "s/;error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/g" /etc/php/7.0/apache2/php.ini \
    && sed -i -e "s/Listen 80/Listen ${APACHE_PORT}/g" /etc/apache2/ports.conf \
    && sed -i -e "s/:80>/:${APACHE_PORT}>/g" /etc/apache2/sites-enabled/000-default.conf

WORKDIR /dustcloud

EXPOSE 80/tcp
EXPOSE 81/tcp
EXPOSE 8053/udp
EXPOSE 1121/tcp

COPY docker_start.sh /
RUN chmod 755 /docker_start.sh

ENV DUSTCLOUDIP 192.168.1.129

CMD /docker_start.sh
