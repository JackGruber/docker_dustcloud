FROM debian

RUN apt-get update && apt-get install -y \
    authbind \
    curl \
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
    && sed -i -e "s/my_cloudserver_ip = \"10.0.0.1\"/my_cloudserver_ip = \"${CLOUDSERVERIP}\"/g" server.py \
    && unset MYSQLPW

EXPOSE 80/tcp
EXPOSE 8053/udp
EXPOSE 1121/tcp

CMD /dustcloud/server.sh
