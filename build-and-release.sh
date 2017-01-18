#!/bin/bash

docker build -t soon/dind-node-build-runner . && \
  NODE_VER=$(docker run --rm --privileged soon/dind-node-build-runner node --version) && \
  IMAGE_TAG=${NODE_VER#"v"} && \
  docker tag -f soon/dind-node-build-runner soon/dind-node-build-runner:$IMAGE_TAG && \
  docker push soon/dind-node-build-runner
