#!/bin/bash
set -e

SCRIPT_DIR=$(dirname $0)
mkdir -p ${SCRIPT_DIR}/workspace
cd ${SCRIPT_DIR}/workspace

cp -R ../settings/* .

cp -R ../stages/stage1/* .
terraform init
terraform apply -auto-approve

cp -R ../stages/stage2/* .
terraform init
terraform apply -auto-approve

cp -R ../stages/stage3/* .
terraform init
terraform apply -auto-approve

cp -R ../stages/stage4/* .
terraform init
terraform apply -auto-approve
