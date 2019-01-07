#!/usr/bin/env bash

set -euox pipefail

mkdir /tmp/tmpwheel /tmp/wheels

dist=$(echo $DOCKER_TAG | sed s/.*://)
sed s/__DOCKER_TAG__/$DOCKER_TAG/ Dockerfile > Dockerfile.debian-${dist}
docker build -f Dockerfile.debian-${dist} -t debian-${dist}-image .
docker run -d --name debian-${dist}-container debian-${dist}-image
docker cp debian-${dist}-container:dist/. /tmp/tmpwheel
(
cd /tmp/tmpwheel
for src in *; do
   mv $src /tmp/wheels/${dist}-${src}
done
)
