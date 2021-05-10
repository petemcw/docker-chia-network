FROM ubuntu:focal

# environment
ARG TAG=1.1.5
ENV TZ="America/Chicago" \
    DEBIAN_FRONTEND="noninteractive" \
    FARMER_ADDRESS="null" \
    FARMER_PORT="null" \
    FARMER="false" \
    FULL_NODE_PORT="null" \
    HARVESTER="false" \
    KEYS="generate" \
    PLOTS_DIR="/farm/plots" \
    PLOTS_TMP_DIR="/farm/tmp" \
    TESTNET="false"

# packages & configure
RUN \
    echo "**** install runtime packages ****" && \
    apt-get update && \
    apt-get install -y \
        acl \
        ansible \
        apt \
        bash \
        build-essential \
        ca-certificates \
        curl \
        git \
        jq \
        nfs-common \
        openssl \
        python-is-python3 \
        python3 \
        python3-dev \
        python3-pip \
        python3.8-distutils \
        python3.8-venv \
        sudo \
        tar \
        unzip \
        vim \
        wget && \
    echo "**** cloning project ****" && \
    git clone --branch ${TAG} https://github.com/Chia-Network/chia-blockchain.git /app && \
    cd /app && \
    git submodule update --init mozilla-ca && \
    echo "**** installing project ****" && \
    mkdir -p \
        /farm/plots \
        /farm/tmp && \
    chmod +x install.sh && \
    /usr/bin/sh ./install.sh && \
    echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

# copy root filesystem
WORKDIR /app
COPY ./entrypoint.sh entrypoint.sh

# external
EXPOSE 8444 8555
VOLUME ["/farm/plots", "/farm/tmp"]
ENTRYPOINT [ "bash", "./entrypoint.sh" ]
