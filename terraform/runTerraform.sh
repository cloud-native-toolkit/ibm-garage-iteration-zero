#!/bin/bash
set -e

SCRIPT_DIR=$(dirname $0)
mkdir -p ${SCRIPT_DIR}/workspace
cd ${SCRIPT_DIR}/workspace

cp -R ../settings/* .

echo -n "Create a (n)ew cluster or use an (e)xisting one? [N/e] "
read CLUSTER_TYPE

if [[ -z "${CLUSTER_TYPE}" ]] || [[ "${CLUSTER_TYPE}" =~ [Nn] ]]; then
    echo "Creating new cluster"
    cp -R ../stages/_stage1/new_cluster/* .
elif [[ "${CLUSTER_TYPE}" =~ [Ee] ]]; then
    echo "Preparing existing cluster"
    cp -R ../stages/_stage1/existing_cluster/* .
fi

terraform init
terraform apply -auto-approve

ls -d ../stages/stage* | while read stage; do
    echo "Running stage: ${stage}"

    cp -R ${stage}/* .

    terraform init

    terraform apply -auto-approve
done
