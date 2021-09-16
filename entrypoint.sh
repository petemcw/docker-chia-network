#!/usr/bin/env bash

PLOTS_DIR=${PLOTS_DIR:-/farm/plots}
PLOTS_TMP_DIR=${PLOTS_TMP_DIR:-/farm/tmp}

if [[ -n "${TZ}" ]]; then
    echo "Setting timezone to ${TZ}"
    ln -nfs "/usr/share/zoneinfo/${TZ}" /etc/localtime && echo "${TZ}" >/etc/timezone
fi

cd /app || return 1

# shellcheck disable=SC1091
source ./activate

chia init --fix-ssl-permissions

if [[ "${TESTNET}" == "true" ]]; then
    echo "Configuring testnet."
    chia configure --testnet true
fi

if [[ "${KEYS}" == "persistent" ]]; then
    echo "Not touching key directories"
elif [[ "${KEYS}" == "generate" ]]; then
    echo "Pass your own keys as a mounted file: -v /path/to/key.file:/path/in/container"
    chia keys generate
elif [[ "${KEYS}" == "copy" ]]; then
    if [[ -z "${CA}" ]]; then
        echo "A path to a copy of a farmer peer's SSL/CA directory is required."
        exit
    else
        chia init -c "${CA}"
    fi
else
    chia keys add -f "${KEYS}"
fi

for p in ${PLOTS_DIR//:/ }; do
    mkdir -p "${p}"
    if [[ ! "$(ls -A "${PLOTS_DIR}")" ]]; then
        echo "Plot directory '${p}' appears to be empty, try mounting a plot directory"
    fi
    chia plots add -d "${p}"
done

sed -i 's/localhost/127.0.0.1/g' "${CHIA_ROOT}/config/config.yaml"

exec "$@"
