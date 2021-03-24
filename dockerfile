FROM alpine:3

RUN set -eu; \
    apk add --no-cache \
        bash vim;

RUN set -eu; \
    apk add busybox-extras;

## AWS CLI
RUN set -eu; \
    apk add --no-cache \
        python3 \
        py3-pip; \
    pip3 install --upgrade pip; \
    pip3 install \
        awscli;

## Postgres Client
RUN set -eu; \
    apk  --no-cache add postgresql-client

## Redis Client
RUN set -eu; \
    apk  --no-cache add redis stunnel; \
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
