#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)
SRC_DIR="$(cd "${SCRIPT_DIR}"; pwd -P)"

cd ${SRC_DIR}

echo ""
cp ${SRC_DIR}/../stages/variables.tf ${SRC_DIR}
cp ${SRC_DIR}/../stages/stage*.tf ${SRC_DIR}

terraform init && terraform apply -auto-approve
