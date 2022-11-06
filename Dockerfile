
ARG ALPINE_VERSION="3.16"
FROM crazymax/alpine-s6:${ALPINE_VERSION}-2.2.0.3

ENV PNPM_HOME=/root/.local/share/pnpm \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/share/pnpm:/root/.local/share/pnpm/global/5/node_modules:$PNPM_HOME \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash

WORKDIR /root

RUN apk --no-cache add -f bash \
                             git \
                             curl \
                             wget \
                             nodejs \
                             npm \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && npm install -g pnpm \
    && npm install -g n \
    && n lts \
    && pnpm add -g pm2 \
    && npm i -g oicq@1 \
    && rm -rf /root/.pnpm-store \
    && rm -rf /root/.local/share/pnpm/store \
    && rm -rf /root/.cache \
    && rm -rf /root/.npm


