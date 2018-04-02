#!/bin/sh
set -e
cd $(dirname $0)

case $( uname -m ) in
armv6l)
  REPO="jackgruber/dustcloud_pi"
  ;;
x86_64)
  REPO="jackgruber/dustcloud"
  ;;
*)
  echo "Unknown arch $( uname -p )"
  exit 1
  ;;
esac

docker build -t $REPO .
docker push $REPO
