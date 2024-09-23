FROM alpine:3 AS redis-cli-builder

ARG REDIS_VERSION="6.2.7"
ARG REDIS_DOWNLOAD_URL="http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz"

RUN set -eux; \
  apk add --update --no-cache --virtual build-deps gcc make linux-headers musl-dev tar tcl-tls openssl-dev ca-certificates; \
  wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL"; \
  mkdir -p /usr/src/redis; \
  tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1; \
  BUILD_TLS=yes make -C /usr/src/redis redis-cli; \
  /usr/src/redis/src/redis-cli --version

FROM alpine:3

RUN set -eux; \
  apk add --no-cache \
  bash vim curl;

RUN set -eux; \
  apk add \
  openssl \
  busybox-extras \
  bind-tools;

RUN set -eux; \
  apk add --no-cache \
  python3;

## AWS CLI
RUN set -eux; \
  apk add --no-cache \
  aws-cli \
  aws --version;

## GCP Cli
RUN set -eux; \
  curl https://sdk.cloud.google.com > gcloud-install.sh; \
  bash gcloud-install.sh --disable-prompts --install-dir=/usr/lib; \
  rm gcloud-install.sh; \
  ln -s /usr/lib/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud; \
  gcloud --version; \
  gcloud components install gke-gcloud-auth-plugin

ENV USE_GKE_GCLOUD_AUTH_PLUGIN=True

## kubectl
RUN set -eux; \
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
  curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"; \
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c; \
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; \
  rm kubectl kubectl.sha256; \
  kubectl version --client

## Postgres Client
RUN set -eux; \
  apk  --no-cache add postgresql-client

## Redis Client
COPY --from=redis-cli-builder  /usr/src/redis/src/redis-cli /usr/local/bin/redis-cli

## stunnel
RUN set -eux; \
  apk  --no-cache add stunnel; \
  mkdir -p /run/stunnel; \
  chown stunnel.stunnel -R /run/stunnel; \
  mkdir -p /var/log/stunnel; \
  chown stunnel.stunnel -R /var/log/stunnel

COPY ./src/stunnel-redis-cli.sh /usr/local/bin/stunnel-redis-cli

RUN set -eux; \
  chmod +x /usr/local/bin/stunnel-redis-cli;

## ClamAV Scan
RUN set -eux; \
  apk --no-cache add clamav-clamdscan

COPY ./src/clamdscan-conf.sh /usr/local/bin/clamdscan-conf

RUN set -eux; \
  chmod +x /usr/local/bin/clamdscan-conf;

RUN rm -rf /var/cache/apk/*

ENV PS1="$ "

ENTRYPOINT [ "bash" ]
