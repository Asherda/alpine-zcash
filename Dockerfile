FROM alpine:edge

MAINTAINER James Edwards <james.p.edwards42@gmail.com> (@jamespedwards)

RUN addgroup -S zcash && adduser -S -G zcash zcash \
  && mkdir -p /zcash/data \
  && chown zcash:zcash /zcash/data

ARG ZCASH_GIT_URL=https://github.com/daira/zcash.git
ARG ZCASH_BRANCH=1558.alpine-linux-fixes

VOLUME /zcash/data

RUN set -x \
  && apk add --update --no-cache --virtual .build-deps \
    autoconf \
    automake \
    boost-dev \
    build-base \
    chrpath \
    curl \
    file \
    git \
    libtool \
    linux-headers \
    m4 \
    musl-dev \
    ncurses-dev \
    openssl \
    openssl-dev \
    pkgconfig \
    tar \
    unzip \
    wget \
    zlib-dev \
  && mkdir -p /usr/src \
  && git clone -b "$ZCASH_BRANCH $ZCASH_GIT_URL" /usr/src/zcash \
  && cd /usr/src/zcash \
  && /bin/bash ./zcutil/fetch-params.sh \
  && /bin/bash ./zcutil/build.sh -j4 \
  && cd /usr/src/zcash/src \
  && install -s -c bitcoin-tx zcashd zcash-cli zcash-gtest -t /usr/local/bin/ \
  && cd /zcash \
  && rm -rf /usr/src/zcash \
  && apk del .build-deps

USER zcash
ENTRYPOINT ["/usr/local/bin/zcashd"]
CMD ["--help"]
