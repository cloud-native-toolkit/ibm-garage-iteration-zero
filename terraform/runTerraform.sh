#!/bin/bash
set -e

SCRIPT_DIR=$(dirname $0)
mkdir -p ${SCRIPT_DIR}/workspace
cd ${SCRIPT_DIR}/workspace

cp -R ../settings/* .

CLUSTER_TYPE="x"
while [[ "${CLUSTER_TYPE}" =~ [^ne] ]]; do
    echo -n "Create a (n)ew cluster or use an (e)xisting one? [N/e] "
    read CLUSTER_TYPE

    if [[ -z "${CLUSTER_TYPE}" ]] || [[ "${CLUSTER_TYPE}" =~ [Nn] ]]; then
        CLUSTER_TYPE="n"
    elif [[ "${CLUSTER_TYPE}" =~ [Ee] ]]; then
        CLUSTER_TYPE="e"
    fi
done

if [[ "${CLUSTER_TYPE}" == "e" ]]; then
    echo "You have chosen to use an existing cluster. Before configuring the environment the following namespaces and all their contents will be destroyed: tools, dev, test, prod"

    proceed="x"
    while [[ "${proceed}" =~ [^yn] ]]; do
        echo -n "Do you want to proceed? [Y/n] "
        read proceed

        if [[ "${proceed}" == "" ]] || [[ "${proceed}" =~ [Yy] ]]; then
            proceed="y"
        elif [[ "${proceed}" =~ [Nn] ]]; then
            proceed="n"
        fi
    done

    if [[ "${proceed}" == "y" ]]; then
        CLUSTER_TYPE="e"
    else
        CLUSTER_TYPE="n"
    fi
fi


echo ""
if [[ "${CLUSTER_TYPE}" == "n" ]]; then
    echo "Creating new cluster"
    cp -R ../stages/_stage1/new_cluster/* .
elif [[ "${CLUSTER_TYPE}" == "e" ]]; then
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
