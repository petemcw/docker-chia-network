#!/usr/bin/env bash

if [[ "${FARMER}" == "true" ]]; then
    chia start farmer-only
elif [[ "${HARVESTER}" == "true" ]]; then
    if [[ -z "${FARMER_ADDRESS}" || -z "${FARMER_PORT}" || -z "${CA}" ]]; then
        echo "A farmer peer address, port, and CA path are required."
        exit
    else
        chia configure --set-farmer-peer "${FARMER_ADDRESS}:${FARMER_PORT}"
        chia start harvester
    fi
else
    chia start farmer
fi

# ensure log file can be tailed
touch "${CHIA_ROOT}/log/debug.log"
tail -f "${CHIA_ROOT}/log/debug.log"
