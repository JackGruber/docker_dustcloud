#!/bin/sh
REPO="jackgruber/dustcloud"

arch=$( uname -m )

if [ "$1" = "test" ]; then
  arch="test"
fi

docker build -t $REPO:$arch \
--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
--build-arg VCS_REF=`git rev-parse --short HEAD` \
--build-arg BRANCH=`git rev-parse --abbrev-ref HEAD` .

if [ "$1" != "test" ]; then
  case $arch in
  armv7l)
    docker tag $REPO:$arch $REPO:rpi
    docker tag $REPO:$arch $REPO:rpi3
    docker tag $REPO:$arch $REPO:arm
    ;;
  armv6l)
    docker tag $REPO:$arch $REPO:rpizw
    ;;
  x86_64)
    docker tag $REPO:$arch $REPO
    ;;
  *)
    echo "Unknown arch $( uname -m )"
    exit 1
  ;;
  esac

  if [ "$1" = "push" ]; then
    docker rmi $REPO:test
    docker push $REPO
  fi
fi
