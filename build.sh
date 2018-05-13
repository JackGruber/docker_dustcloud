#!/bin/sh
REPO="jackgruber/dustcloud"

ARCH=$(dpkg --print-architecture)

if [ "$1" = "test" ]; then
  ARCH="test"
fi

docker build -t $REPO:$ARCH \
--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
--build-arg VCS_REF=`git rev-parse --short HEAD` \
--build-arg BRANCH=`git rev-parse --abbrev-ref HEAD` .


if [ "$1" = "push" ]; then
  docker rmi $REPO:test
  docker push $REPO
fi
