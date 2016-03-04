#!/bin/bash

docker build -t mcasimir/dind-node-build-runner . && \
  NODE_VER=$(docker run --rm --privileged mcasimir/dind-node-build-runner node --version) && \
  IMAGE_TAG=${NODE_VER#"v"} && \
  docker tag -f mcasimir/dind-node-build-runner mcasimir/dind-node-build-runner:$IMAGE_TAG && \
  docker push mcasimir/dind-node-build-runner
