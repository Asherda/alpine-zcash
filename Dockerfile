FROM alpine:3.4

MAINTAINER James Edwards <james.p.edwards42@gmail.com> (@jamespedwards)

RUN addgroup -S zcash && adduser -S -G zcash zcash \
  && mkdir -p /zcash/data \
  && chown zcash:zcash /zcash/data

ARG ZCASH_GIT_URL=https://github.com/daira/zcash.git
ARG ZCASH_BRANCH=1558.alpine-linux-fixes

VOLUME /zcash/data

RUN set -x \
  && apk add --no-cache --virtual .build-deps \
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
    zlib-dev

RUN mkdir -p /tmp/build \
  && git clone -b "$ZCASH_BRANCH" "$ZCASH_GIT_URL" /tmp/build/zcash \
  && cd /tmp/build/zcash \
  && /bin/bash ./zcutil/fetch-params.sh \
  && /bin/bash ./zcutil/build.sh -j4

RUN cd /tmp/build/zcash/src \
  && install -s -c bitcoin-tx zcashd zcash-cli zcash-gtest -t /usr/local/bin/ \
  && cd /zcash \
  && rm -rf /tmp/build/zcash \
  && apk del .build-deps \
  && apk --no-cache add \
    boost \
    boost-program_options \
    libgomp

WORKDIR /zcash

USER zcash

ENTRYPOINT ["/usr/local/bin/zcashd"]
CMD ["--help"]
