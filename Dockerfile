FROM alpine:edge

MAINTAINER James Edwards <james.p.edwards42@gmail.com> (@jamespedwards)

RUN addgroup -S zcash && adduser -S -G zcash zcash \
  && mkdir -p /zcash/data \
  && chown zcash:zcash /zcash/data

ARG ZCASH_BRANCH=v1.0.0-rc1

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

RUN curl -o zcash.tar.gz https://codeload.github.com/zcash/zcash/tar.gz/"$ZCASH_BRANCH" \
  && mkdir -p /usr/src/zcash \
  && tar -xzf zcash.tar.gz -C /usr/src/zcash --strip-components=1 \
  && rm zcash.tar.gz \
  && cd /usr/src/zcash \
  && /bin/bash ./zcutil/fetch-params.sh

RUN cd /usr/src/zcash \
  && /bin/bash ./zcutil/build.sh -j4

RUN cd /usr/src/zcash/src \
  && install -c bitcoin-tx zcashd zcash-cli zcash-gtest -t /usr/local/bin/ \
  && rm -r /usr/src/zcash \
  && apk del .build-deps

USER zcash
ENTRYPOINT ["/usr/local/bin/zcashd"]
CMD ["--help"]
