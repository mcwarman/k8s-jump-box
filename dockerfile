FROM alpine:3  as redis-cli-builder

ARG REDIS_VERSION="6.2.4"
ARG REDIS_DOWNLOAD_URL="http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz"

RUN set -eu; \
    apk add --update --no-cache --virtual build-deps gcc make linux-headers musl-dev tar tcl-tls openssl-dev ca-certificates; \
    wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL"; \
    mkdir -p /usr/src/redis; \
    tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1; \
    BUILD_TLS=yes make -C /usr/src/redis redis-cli; \
    /usr/src/redis/src/redis-cli --version

FROM alpine:3

RUN set -eu; \
    apk add --no-cache \
        bash vim curl;

RUN set -eu; \
    apk add \
      openssl \
      busybox-extras;

## AWS CLI
RUN set -eu; \
    apk add --no-cache \
        groff \
        less \
        python3 \
        py3-pip; \
    pip3 install --upgrade pip; \
    pip3 install \
        awscli;

## Postgres Client
RUN set -eu; \
    apk  --no-cache add postgresql-client

## Redis Client
COPY --from=redis-cli-builder  /usr/src/redis/src/redis-cli /usr/local/bin/redis-cli

## stunnel
RUN set -eu; \
    apk  --no-cache add stunnel; \
    mkdir -p /run/stunnel; \
    chown stunnel.stunnel -R /run/stunnel; \
    mkdir -p /var/log/stunnel; \
    chown stunnel.stunnel -R /var/log/stunnel

COPY ./src/stunnel-redis-cli.sh /usr/local/bin/stunnel-redis-cli

RUN set -eu; \
    chmod +x /usr/local/bin/stunnel-redis-cli;

RUN rm -rf /var/cache/apk/*

ENV PS1="$ "

ENTRYPOINT [ "bash" ]
