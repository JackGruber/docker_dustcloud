#!/bin/sh
set -e
cd $(dirname $0)

case $( uname -m ) in
armv7l)
  REPO="angelnu/iobroker-arm"
  ;;
x86_64)
  REPO="angelnu/iobroker-amd64"
  ;;
*)
  echo "Unknown arch $( uname -p )"
  exit 1
  ;;
esac

echo $REPO
#docker build -t $REPO .
#docker push $REPO
