#!/bin/bash
REPO="jackgruber/dustcloud"

ARCH=$(dpkg --print-architecture)

if [ "$1" = "manifest" ]; then
  DIR="${REPO/\//_}"
  rm -rf ~/.docker/manifests/docker.io_${DIR}-latest/
  docker manifest create \
    $REPO:latest \
    $REPO:armhf \
    $REPO:amd64

  docker manifest push $REPO:latest

  docker manifest inspect $REPO
else
  if [ "$1" = "test" ]; then
    ARCH="test"
  fi

  docker build -t $REPO \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg BRANCH=`git rev-parse --abbrev-ref HEAD` .

  docker tag $REPO $REPO:$ARCH

  if [ "$1" = "push" ]; then
    docker rmi $REPO:test
    docker push $REPO
  fi
fi
