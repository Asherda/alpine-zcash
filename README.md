# [Alpine Zcash Docker Image](https://hub.docker.com/r/jamespedwards42/alpine-zcash/)

## Supported Tags

All images are FROM alpine:edge

* [`latest`](https://github.com/jamespedwards42/alpine-zcash/blob/master/Dockerfile)

## Docker Run
```shell
docker run -d \
  --name zcash-testnet \
  -v /host/dir:/zcash/data \
  -p 18232:18232/tcp \
    jamespedwards42/alpine-zcash:latest \
      -addnode betatestnet.z.cash \
      -daemon \
      -datadir /zcash/data \
      -rpcuser PICK_A_USERNAME \
      -rpcpassword SUPER_COMPLEX_PASSWORD \
      -testnet
```

## Docker Compose
```yaml
version: '2'

services:
  zcash-testnet:
    ports:
      - "18232:18232"
    volumes:
      - /host/dir:/zcash/data
    image: jamespedwards42/alpine-zcash:latest
    command: ['-addnode', 'betatestnet.z.cash', '-daemon', '-datadir', '/zcash/data', '-rpcuser', 'PICK_A_USERNAME', '-rpcpassword', 'SUPER_COMPLEX_PASSWORD', '-testnet']
```

## Docker Build
```sh
docker build \
  --build-arg ZCASH_GIT_URL=https://github.com/daira/zcash.git \
  --build-arg ZCASH_BRANCH=1558.alpine-linux-fixes \
  -t jamespedwards42/alpine-zcash:version .
```
