FROM python:3.8.8-alpine3.13
# FROM python:alpine

ARG OICQ_MAINTAINER="lhpmain"
LABEL maintainer="${OICQ_MAINTAINER}"
ARG OICQ_URL=https://github.com/${OICQ_MAINTAINER}/docker-oicq.git
ARG OICQ_BRANCH=main

ENV PNPM_HOME=/root/.local/share/pnpm \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/share/pnpm:/usr/local/bin/node:/root/.local/share/pnpm/global/5/node_modules:$PNPM_HOME \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ " \
    OICQ_DIR=/oicq \
    OICQ_BRANCH=${OICQ_BRANCH}

WORKDIR ${OICQ_DIR}

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache bash \
                             coreutils \
                             moreutils \
                             git \
                             curl \
                             wget \
                             tzdata \
                             perl \
                             openssl \
                             nodejs \
                             jq \
                             openssh \
                             npm \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && git clone -b ${OICQ_BRANCH} ${OICQ_URL} ${OICQ_DIR} \
    && cd ${OICQ_DIR} \
    && chmod 777 ${OICQ_DIR}/*.sh \
    && npm install -g pnpm \
    && npm install -g n \
    && n lts \
    && pnpm add -g pm2 \
    && npm i -g oicq@1 \
    && rm -rf /root/.pnpm-store \
    && rm -rf /root/.local/share/pnpm/store \
    && rm -rf /root/.cache \
    && rm -rf /root/.npm
EXPOSE 8008 8089
# ENTRYPOINT ["./docker-entrypoint.sh"]
