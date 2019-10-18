#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)
CLUSTER_TYPE=$1
SRC_DIR="$(cd "${SCRIPT_DIR}"; pwd -P)"

cd ${SRC_DIR}

echo ""
cp ${SRC_DIR}/../stages/variables.tf ${SRC_DIR}

if [ $CLUSTER_TYPE == "openshift" ]; then
    cp ${SRC_DIR}/../stages-crc/stage*.tf ${SRC_DIR}
else
    cp ${SRC_DIR}/../stages/stage*.tf ${SRC_DIR}
fi

terraform init && terraform apply -auto-approve
