#!/bin/bash
set -e

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  echo "Usage: runTerraform.sh [--auto-approve] [--keep|--delete]"
  echo ""
  echo "  --auto-approve - proceed with the install without being prompted (optional)"
  echo "  --keep         - will automatically keep the workspace directory if it already exists (optional)"
  echo "  --delete       - will automatically delete the workspace directory if it already exists (optional)"
  exit 0
fi

SCRIPT_DIR=$(dirname "$0")
SRC_DIR="$(cd "${SCRIPT_DIR}"; pwd -P)"

ENVIRONMENT_TFVARS="${SRC_DIR}/settings/environment.tfvars"

CLUSTER_NAME=$(grep -E "^cluster_name" "${ENVIRONMENT_TFVARS}" | sed -E "s/^cluster_name=\"(.*)\".*/\1/g")
RESOURCE_GROUP_NAME=$(grep -E "^resource_group_name" "${ENVIRONMENT_TFVARS}" | sed -E "s/^resource_group_name=\"(.*)\".*/\1/g")
NAME_PREFIX=$(grep -E "^name_prefix" "${ENVIRONMENT_TFVARS}" | sed -E "s/^name_prefix=\"(.*)\".*/\1/g")

if [[ -z "${CLUSTER_NAME}" ]]; then
  if [[ -n "${NAME_PREFIX}" ]]; then
    CLUSTER_NAME="${NAME_PREFIX}-cluster"
  else
    CLUSTER_NAME="${RESOURCE_GROUP_NAME}-cluster"
  fi

  WRITE_CLUSTER_NAME="true"
fi

WORKSPACE_DIR="${SRC_DIR}/workspaces/${CLUSTER_NAME}"

if [[ -d "${WORKSPACE_DIR}" ]]; then
  echo -e "A workspace directory already exists for this cluster: \033[1;33m${CLUSTER_NAME}\033[0m"

  if [[ "$1" == "--delete" ]] || [[ "$2" == "--delete" ]]; then
    ANSWER="d"
  elif [[ "$1" == "--keep" ]] || [[ "$2" == "--keep" ]]; then
    ANSWER="k"
  else
    ANSWER="x"
  fi

  while [[ "${ANSWER}" =~ [^kd] ]]; do
    echo -n "Do you want to (k)eep the state or (d)elete it and start over? [K/d] "
    read -r ANSWER

    if [[ -z "${ANSWER}" ]] || [[ "${ANSWER}" =~ [Kk] ]]; then
        ANSWER="k"
    elif [[ "${ANSWER}" =~ [Dd] ]]; then
        ANSWER="d"
    fi
  done

  if [[ "${ANSWER}" == "d" ]]; then
    echo -e "   Deleting old workspace directory: \033[1;33m${CLUSTER_NAME}\033[0m"
    rm -rf "${WORKSPACE_DIR}"
  else
    echo -e "   Adding configuration to existing workspace directory: \033[1;33m${CLUSTER_NAME}\033[0m"
  fi
fi

mkdir -p "${WORKSPACE_DIR}"

TFVARS="${WORKSPACE_DIR}/terraform.tfvars"

cat "${ENVIRONMENT_TFVARS}" > "${TFVARS}"
cat "${SRC_DIR}/settings/vlan.tfvars" >> "${TFVARS}"
echo "" >> "${TFVARS}"
cp "${SRC_DIR}"/scripts-workspace/* "${WORKSPACE_DIR}"

# Read terraform.tfvars to see if cluster_exists, postgres_server_exists, and cluster_type are set
# If not, get them from the user and write them to a file

CLUSTER_MANAGEMENT="ibmcloud"

if [[ -n "${WRITE_CLUSTER_NAME}" ]]; then
  echo "cluster_name=\"${CLUSTER_NAME}\"" >> "${TFVARS}"
fi

CLUSTER_EXISTS=$(grep -E "^cluster_exists" "${TFVARS}" | sed -E "s/^cluster_exists=\"(.*)\".*/\1/g")
if [[ -z "${CLUSTER_EXISTS}" ]]; then
    ANSWER="x"
    while [[ "${ANSWER}" =~ [^ne] ]]; do
        echo -n "Do you want to create a (n)ew cluster or configure an (e)xisting cluster? [N/e] "
        read -r ANSWER

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
        echo "cluster_exists=\"false\"" >> "${TFVARS}"
    fi

    echo "cluster_exists=\"${CLUSTER_EXISTS}\"" >> "${TFVARS}"
fi

CLUSTER_TYPE=$(grep -E "^cluster_type" "${TFVARS}" | sed -E "s/^cluster_type=\"(.*)\".*/\1/g")
if [[ -z "${CLUSTER_TYPE}" ]]; then
    ANSWER="x"
    while [[ "${ANSWER}" =~ [^okc] ]]; do
        if [[ "${CLUSTER_EXISTS}" == "false" ]]; then
            echo -n "Do you want to create a (k)ubernetes cluster or an [O]penShift cluster? [K/o] "
        else
            echo -n "Is your existing cluster (k)ubernetes, [O]penShift, or [C]odeReady Container? [K/o/c] "
        fi
        read -r ANSWER

        if [[ -z "${ANSWER}" ]] || [[ "${ANSWER}" =~ [Kk] ]]; then
            ANSWER="k"
        elif [[ "${ANSWER}" =~ [Oo] ]]; then
            ANSWER="o"
        elif [[ "${ANSWER}" =~ [Cc] ]]; then
            ANSWER="c"
        fi
    done

    if [[ "${ANSWER}" == "k" ]]; then
        CLUSTER_TYPE="kubernetes"
    elif [[ "${ANSWER}" == "c" ]]; then
        CLUSTER_TYPE="crc"
    else
        CLUSTER_TYPE="openshift"
    fi

    echo "cluster_type=\"${CLUSTER_TYPE}\"" >> "${TFVARS}"
fi

if [[ "${CLUSTER_TYPE}" == "crc" ]]; then
    CLUSTER_TYPE="ocp4"
    CLUSTER_MANAGEMENT="crc"
    MANAGED_BY=" managed by \033[1;33mcrc\033[0m"
fi

sed "s/^cluster_type=.*/cluster_type=\"${CLUSTER_TYPE}\"/g" < "${TFVARS}" > "${TFVARS}.tmp" && \
    rm "${TFVARS}" && \
    mv "${TFVARS}.tmp" "${TFVARS}"
#echo "cluster_type=\"${CLUSTER_TYPE}\"" >> ${TFVARS}

echo -e ""
echo -e "Terraform is about to run with the following settings:"
echo -e "  - Resource group \033[1;33m${RESOURCE_GROUP_NAME}\033[0m"
if [[ "${CLUSTER_EXISTS}" == "false" ]]; then
    echo -e "  - Create a new \033[1;33m${CLUSTER_TYPE}\033[0m cluster instance named \033[1;33m${CLUSTER_NAME}\033[0m${MANAGED_BY}"
else
    echo -e "  - Use an existing \033[1;33m${CLUSTER_TYPE}\033[0m cluster instance named \033[1;33m${CLUSTER_NAME}\033[0m${MANAGED_BY}"
    echo ""
    echo -e "\033[1;31mBefore configuring the environment the following namespaces and their contents will be destroyed: tools, dev, test, staging\033[0m"
fi

if [[ "crc" ==  "${CLUSTER_MANAGEMENT}" ]]; then
	STAGES_DIRECTORY="stages-crc"
else
	STAGES_DIRECTORY="stages"
fi

cp "${SRC_DIR}/${STAGES_DIRECTORY}/variables.tf" "${WORKSPACE_DIR}"
cp "${SRC_DIR}/${STAGES_DIRECTORY}"/stage*.tf "${WORKSPACE_DIR}"

echo ""

if [[ "$1" != "--auto-approve" ]] && [[ "$2" != "--auto-approve" ]]; then
    PROCEED="x"
    while [[ "${PROCEED}" =~ [^yn] ]]; do
        echo -n "Do you want to proceed? [Y/n] "
        read -r PROCEED

        if [[ -z "${PROCEED}" ]] || [[ "${PROCEED}" =~ [Yy] ]]; then
            PROCEED="y"
        elif [[ "${PROCEED}" =~ [Nn] ]]; then
            exit 1
        fi
    done
fi

cd "${WORKSPACE_DIR}"

./apply.sh
