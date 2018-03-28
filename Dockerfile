FROM debian

RUN apt-get update && apt-get install -y \
    git \
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

# copy dustcloud proxy
RUN mkdir /dustcloud_git \
    && mkdir /dustcloud \
    && git clone --depth=1 https://github.com/dgiese/dustcloud.git /dustcloud_git \ 
    && cp /dustcloud_git/dustcloud/server.* /dustcloud/ \
    && cp /dustcloud_git/dustcloud/build_map.py /dustcloud/ \
    && chmod +x /dustcloud/server.sh \
    && rm -r /dustcloud_git

WORKDIR /dustcloud

# IP and password 
RUN sed -i -e 's/pymysql.connect("localhost","dustcloud","","dustcloud")/pymysql.connect("localhost","dustcloud","dustcloudpw","dustcloud")/g' server.py \
    && sed -i -e 's/my_cloudserver_ip = "10.0.0.1"/my_cloudserver_ip = "123.123.123.123"/g' server.py

CMD ["bash"]


