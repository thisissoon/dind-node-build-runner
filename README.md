# dind-node-build-runner

A docker image that provides a running environment to perform builds using common node
js tools and docker in docker.

Tools:

- docker
- docker-compose
- node
- npm
- phantomjs
- chrome
- chromedriver

## Usage

```
docker run --privileged soon/dind-node-build-runner
```

## Build

To build different node and chrome versions you can pass these as arguments at
build time.

```
docker build -t soon/dind-node-build-runner:8 --build-arg NODE_VERSION=8.x --build-arg CHROME_DRIVER_VERSION=2.33 .
```
