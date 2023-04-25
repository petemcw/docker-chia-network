FROM ubuntu:20.04

# environment
LABEL org.opencontainers.image.source https://github.com/petemcw/chia-network
ARG TAG=1.7.1
ENV TZ="America/Chicago" \
    CHIA_ROOT="/root/.chia/mainnet" \
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
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
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
        python3.9-distutils \
        python3.9-venv \
        sudo \
        tar \
        tzdata \
        unzip \
        vim \
        wget && \
    ln -nfs /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
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
ENV PATH=/app/venv/bin:$PATH
WORKDIR /app
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./start.sh /usr/local/bin/start.sh

# external
EXPOSE 8444 8555
VOLUME ["/farm/plots", "/farm/tmp"]
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD ["/usr/local/bin/start.sh"]
