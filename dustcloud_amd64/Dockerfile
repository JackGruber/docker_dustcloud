FROM debian

RUN apt-get update && apt-get install -y \
    apache2 \
    authbind \
    curl \
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

RUN touch /etc/authbind/byport/80 \
    && chown www-data /etc/authbind/byport/80 \
    && chmod 755 /etc/authbind/byport/80

# copy dustcloud proxy
WORKDIR /dustcloud
RUN echo 'su -c "authbind python3 /dustcloud/server.py" -s /bin/bash - www-data' > server.sh \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/server.py --output server.py \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/build_map.py --output build_map.py \
    && curl https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/upload_map.sh --output upload_map.sh \
    && chmod +x /dustcloud/server.sh

# configuration for MySQL Server and public dustcloud IP
# mysqldb = docker network link name
ENV MYSQLIP mysqldb
ENV MYSQLDB dustcloud
ENV MYSQLUSER dustcloud
ENV MYSQLPW dustcloudpw
ENV CLOUDSERVERIP 130.83.47.181

RUN sed -i -e "s/pymysql.connect(\"localhost\", \"dustcloud\", \"\", \"dustcloud\")/pymysql.connect(\"${MYSQLIP}\",\"${MYSQLUSER}\",\"${MYSQLPW}\",\"${MYSQLDB}\")/g" server.py \
    && sed -i -e "s/my_cloudserver_ip = \"10.0.0.1\"/my_cloudserver_ip = \"${CLOUDSERVERIP}\"/g" server.py


ENV APACHE_PID_FILE ${APACHE_RUN_DIR}/apache2.pid
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2

WORKDIR /var/www/html
RUN rm /var/www/html/index.html

# get dustcloud (PHP)
RUN echo "<?php phpinfo(); ?>" > info.php \
    && curl -SL https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/fns.php --output fns.php \
    && curl -SL https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/index.php --output index.php \
    && curl -SL https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/newdevice.php --output newdevice.php \
    && curl -SL https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/show.php --output show.php \
    && curl -SL https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/showcmdlog.php --output showcmdlog.php \
    && curl -SL https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/showlog.php --output showlog.php \
    && curl -SL https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/style.css --output style.css \
    && curl -SL https://raw.githubusercontent.com/dgiese/dustcloud/master/dustcloud/www/config.php.dist --output config.php

# Customization for dustcloud
RUN sed -i -e "s/const DB_HOST = 'localhost';/const DB_HOST = '${MYSQLIP}';/g" config.php \
    && sed -i -e "s/const DB_USER = 'user123';/const DB_USER = '${MYSQLUSER}';/g" config.php \
    && sed -i -e "s/const DB_PASS = '';/const DB_PASS = '${MYSQLPW}';/g" config.php \
    && sed -i -e "s/const DB_NAME = 'dustcloud';/const DB_NAME = '${MYSQLDB}';/g" config.php

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

#CMD /dustcloud/server.sh

COPY docker_start.sh /
RUN chmod 755 /docker_start.sh

#ENTRYPOINT miio client
#CMD ["apache2"]
#CMD ["bash"]


CMD /docker_start.sh
