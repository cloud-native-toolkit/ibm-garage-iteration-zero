#!/bin/bash
set -e

SCRIPT_DIR=$(dirname $0)
SRC_DIR="$(cd "${SCRIPT_DIR}"; pwd -P)"

WORKSPACE_DIR="${SCRIPT_DIR}/workspace"
mkdir -p ${WORKSPACE_DIR}

if [[ ! -f ${WORKSPACE_DIR}/apply.sh ]]; then
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

        if [[ "${proceed}" == "n" ]]; then
            exit 1
        fi
    fi

    echo ""
    if [[ "${CLUSTER_TYPE}" == "n" ]]; then
        echo "Creating new cluster"
        cp -R ${SRC_DIR}/stages/_stage1/new_cluster/* ${WORKSPACE_DIR}
    elif [[ "${CLUSTER_TYPE}" == "e" ]]; then
        echo "Preparing existing cluster"
        cp -R ${SRC_DIR}/stages/_stage1/existing_cluster/* ${WORKSPACE_DIR}
    fi
fi

cp -R ${SRC_DIR}/settings/* ${WORKSPACE_DIR}
cp -R ${SRC_DIR}/scripts/* ${WORKSPACE_DIR}

cd ${WORKSPACE_DIR}
./apply.sh
