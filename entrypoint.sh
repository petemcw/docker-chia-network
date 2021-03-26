#!/usr/bin/env bash

PLOTS_DIR=${PLOTS_DIR:-/farm/plots}
PLOTS_TMP_DIR=${PLOTS_TMP_DIR:-/farm/tmp}

cd /app || return

# shellcheck disable=SC1091
source activate

chia init

if [[ "${KEYS}" == "generate" ]]; then
    echo "Pass your own keys as a variable: -e KEYS=\"24 words\""
    chia keys generate
else
    echo "${KEYS}" | chia keys add
fi

if [[ ! "$(ls -A "${PLOTS_DIR}")" ]]; then
    echo "Plot directory appears to be empty, try mounting a plot directory"
fi

chia plots add -d "${PLOTS_DIR}"

sed -i 's/localhost/127.0.0.1/g' ~/.chia/mainnet/config/config.yaml

if [[ "${TESTNET}" == "true" ]]; then
    if [[ -z "${FULL_NODE_PORT}" || "${FULL_NODE_PORT}" == "null" ]]; then
        chia configure --set-fullnode-port 58444
    else
        chia configure --set-fullnode-port "${FULL_NODE_PORT}"
    fi
fi

if [[ "${FARMER}" == "true" ]]; then
    chia start farmer-only
elif [[ "${HARVESTER}" == "true" ]]; then
    if [[ -z "${FARMER_ADDRESS}" || -z "${FARMER_PORT}" ]]; then
        echo "A farmer peer address and port are required."
        exit
    else
        chia configure --set-farmer-peer "${FARMER_ADDRESS}:${FARMER_PORT}"
        chia start harvester
    fi
else
    chia start farmer
fi

while true; do sleep 30; done
