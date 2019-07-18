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

if [[ -z $(grep -E "^cluster_exists" ${TFVARS}) ]]; then
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
        echo "  You have chosen to use an existing cluster. Before configuring the environnment the following namespaces and their contents will be destroyed: tools, dev, test, prod"

        PROCEED="x"
        while [[ "${PROCEED}" =~ [^yn] ]]; do
            echo -n "  Do you want to proceed? [Y/n] "
            read PROCEED

            if [[ -z "${PROCEED}" ]] || [[ "${PROCEED}" =~ [Yy] ]]; then
                PROCEED="y"
            elif [[ "${PROCEED}" =~ [Nn] ]]; then
                PROCEED="n"
            fi
        done

        if [[ "${PROCEED}" == "n" ]]; then
            exit 1
        fi
    fi

    if [[ "${ANSWER}" == "e" ]]; then
        echo "cluster_exists=\"true\"" >> ${TFVARS}
    else
        CREATE_CLUSTER="true"
        echo "cluster_exists=\"false\"" >> ${TFVARS}
    fi
elif [[ $(grep -q "cluster_exists=\"false\"" ${TFVARS}) -gt 0 ]]; then
    CREATE_CLUSTER="true"
fi

if [[ -z $(grep -E "^cluster_type" ${TFVARS}) ]]; then
    ANSWER="x"
    while [[ "${ANSWER}" =~ [^ok] ]]; do
        if [[ -n "${CREATE_CLUSTER}" ]]; then
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
        echo "cluster_type=\"kubernetes\"" >> ${TFVARS}
    else
        echo "cluster_type=\"openshift\"" >> ${TFVARS}
    fi
fi

if [[ -z $(grep -E "^postgres_server_exists" ${TFVARS}) ]]; then
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
        echo "postgres_server_exists=\"true\"" >> ${TFVARS}
    else
        echo "postgres_server_exists=\"false\"" >> ${TFVARS}
    fi
fi

cd ${WORKSPACE_DIR}
./apply.sh
