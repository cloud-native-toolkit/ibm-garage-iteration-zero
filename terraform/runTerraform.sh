#!/bin/bash
set -e

SCRIPT_DIR=$(dirname $0)
SRC_DIR="$(cd "${SCRIPT_DIR}"; pwd -P)"

WORKSPACE_DIR="${SRC_DIR}/workspace"
mkdir -p ${WORKSPACE_DIR}/.tmp

cp ${SRC_DIR}/settings/* ${WORKSPACE_DIR}
cp ${SRC_DIR}/scripts/* ${WORKSPACE_DIR}

# Read terraform.tfvars to see if cluster_exists, postgres_server_exists, and cluster_type are set
# If not, get them from the user and write them to a file

TFVARS="${WORKSPACE_DIR}/terraform.tfvars"

RESOURCE_GROUP_NAME=$(grep -E "^resource_group_name" ${TFVARS} | sed -E "s/^resource_group_name=\"(.*)\".*/\1/g")
CLUSTER_NAME=$(grep -E "^cluster_name" ${TFVARS} | sed -E "s/^cluster_name=\"(.*)\".*/\1/g")

CLUSTER_EXISTS=$(grep -E "^cluster_exists" ${TFVARS} | sed -E "s/^cluster_exists=\"(.*)\".*/\1/g")
if [[ -z "${CLUSTER_EXISTS}" ]]; then
    ANSWER="x"
    while [[ "${ANSWER}" =~ [^ne] ]]; do
        echo -n "Do you want to create a (n)ew cluster or configure an (e)xisting cluster? [N/e] "
        read ANSWER

        if [[ -z "${ANSWER}" ]] || [[ "${ANSWER}" =~ [Nn] ]]; then
            ANSWER="n"
        elif [[ "${ANSWER}" =~ [Ee] ]]; then
            ANSWER="e"
        fi
    done

    if [[ "${ANSWER}" == "e" ]]; then
        CLUSTER_EXISTS="true"
    else
        CLUSTER_EXISTS="false"
        echo "cluster_exists=\"false\"" >> ${TFVARS}
    fi

    echo "cluster_exists=\"${CLUSTER_EXISTS}\"" >> ${TFVARS}
fi

CLUSTER_TYPE=$(grep -E "^cluster_type" ${TFVARS} | sed -E "s/^cluster_type=\"(.*)\".*/\1/g")
if [[ -z "${CLUSTER_TYPE}" ]]; then
    ANSWER="x"
    while [[ "${ANSWER}" =~ [^ok] ]]; do
        if [[ "${CLUSTER_EXISTS}" == "false" ]]; then
            echo -n "Do you want to create a (k)ubernetes cluster or an OpenShift cluster? [K/o] "
        else
            echo -n "Is your existing cluster (k)ubernetes or OpenShift? [K/o] "
        fi
        read ANSWER

        if [[ -z "${ANSWER}" ]] || [[ "${ANSWER}" =~ [Kk] ]]; then
            ANSWER="k"
        elif [[ "${ANSWER}" =~ [Oo] ]]; then
            ANSWER="o"
        fi
    done

    if [[ "${ANSWER}" == "k" ]]; then
        CLUSTER_TYPE="kubernetes"
    else
        CLUSTER_TYPE="openshift"
    fi

    echo "cluster_type=\"${CLUSTER_TYPE}\"" >> ${TFVARS}
fi

POSTGRES_SERVER_EXISTS=$(grep -E "^postgres_server_exists" ${TFVARS} | sed -E "s/^postgres_server_exists=\"(.*)\".*/\1/g")
if [[ -z "${POSTGRES_SERVER_EXISTS}" ]]; then
    ANSWER="x"
    while [[ "${ANSWER}" =~ [^ne] ]]; do
        echo -n "Do you want to create a (n)ew postgres server or configure an (e)xisting postgres server? [N/e] "
        read ANSWER

        if [[ -z "${ANSWER}" ]] || [[ "${ANSWER}" =~ [Nn] ]]; then
            ANSWER="n"
        elif [[ "${ANSWER}" =~ [Ee] ]]; then
            ANSWER="e"
        fi
    done

    if [[ "${ANSWER}" == "e" ]]; then
        POSTGRES_SERVER_EXISTS="true"
    else
        POSTGRES_SERVER_EXISTS="false"
    fi

    echo "postgres_server_exists=\"${POSTGRES_SERVER_EXISTS}\"" >> ${TFVARS}
fi

echo -e ""
echo -e "Terraform is about to run with the following settings:"
echo -e "  - Resource group \033[1;33m${RESOURCE_GROUP_NAME}\033[0m"
if [[ "${POSTGRES_SERVER_EXISTS}" == "false" ]]; then
    echo -e "  - Create a new postgres instance"
else
    echo -e "  - Use an existing postgres instance"
fi
if [[ "${CLUSTER_EXISTS}" == "false" ]]; then
    echo -e "  - Create a new \033[1;33m${CLUSTER_TYPE}\033[0m cluster instance named \033[1;33m${CLUSTER_NAME}\033[0m"
else
    echo -e "  - Use an existing \033[1;33m${CLUSTER_TYPE}\033[0m cluster instance named \033[1;33m${CLUSTER_NAME}\033[0m"
    echo ""
    echo -e "\033[1;31mBefore configuring the environment the following namespaces and their contents will be destroyed: tools, dev, test, prod\033[0m"
fi

echo ""

PROCEED="x"
while [[ "${PROCEED}" =~ [^yn] ]]; do
    echo -n "Do you want to proceed? [Y/n] "
    read PROCEED

    if [[ -z "${PROCEED}" ]] || [[ "${PROCEED}" =~ [Yy] ]]; then
        PROCEED="y"
    elif [[ "${PROCEED}" =~ [Nn] ]]; then
        exit 1
    fi
done

cd ${WORKSPACE_DIR}
./apply.sh
