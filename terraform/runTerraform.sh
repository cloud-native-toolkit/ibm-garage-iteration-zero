#!/bin/bash
set -e

SCRIPT_DIR=$(dirname $0)
mkdir -p ${SCRIPT_DIR}/workspace
cd ${SCRIPT_DIR}/workspace

cp -R ../settings/* .

ls ../stages | while read stage; do
    echo "Running stage: ${stage}"

    cp -R ../stages/${stage}/* .

    if [[ -n "$1" ]]; then
        terraform init -backend-config="$1"
    else
        terraform init
    fi

    terraform apply -auto-approve
done
