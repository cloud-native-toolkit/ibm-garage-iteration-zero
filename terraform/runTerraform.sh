#!/bin/bash
set -e

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  echo "Usage: runTerraform.sh [--auto-approve|-a] [--keep|-k|--delete|-d] [--ocp|--ibmcloud]"
  echo ""
  echo "  --auto-approve, -a - proceed with the install without being prompted (optional)"
  echo "  --keep, -k         - will automatically keep the workspace directory if it already exists (optional)"
  echo "  --delete, -d       - will automatically delete the workspace directory if it already exists (optional)"
  echo "  --ocp              - install the Toolkit into a self-managed OpenShift container platform (optional)"
  echo "  --ibmcloud, --ibm  - install the Toolkit into an IBM Cloud managed Kubernetes or OpenShift container platform (optional)"
  echo "  --help, -h         - print this message"
  exit 0
fi

SCRIPT_DIR=$(dirname "$0")
SRC_DIR="$(cd "${SCRIPT_DIR}"; pwd -P)"

if [[ "${*:1}" =~ "--ocp" ]]; then
  CLUSTER_MANAGEMENT="o"
elif [[ "${*:1}" =~ "--ibm" ]]; then
  CLUSTER_MANAGEMENT="i"
else
  CLUSTER_MANAGEMENT="x"
  until [[ -n "${CLUSTER_MANAGEMENT}" ]] && [[ "${CLUSTER_MANAGEMENT}" =~ ^[oi]$ ]]; do
    echo -n "Deploy Toolkit on (I)BM Cloud-managed IKS/ROKS or (O)penShift container platform? [I/o] "
    read -r CLUSTER_MANAGEMENT

    if [[ -z "${CLUSTER_MANAGEMENT}" ]] || [[ "${CLUSTER_MANAGEMENT}" =~ [Ii] ]]; then
      CLUSTER_MANAGEMENT="i"
    elif [[ "${CLUSTER_MANAGEMENT}" =~ [Oo] ]]; then
      CLUSTER_MANAGEMENT="o"
    fi
  done
  echo ""
fi

if [[ "${CLUSTER_MANAGEMENT}" == "i" ]]; then
  ENVIRONMENT_TFVARS="${SRC_DIR}/settings/environment-ibmcloud.tfvars"

  CLUSTER_NAME=$(grep -E "^cluster_name" "${ENVIRONMENT_TFVARS}" | sed -E "s/^cluster_name=\"(.*)\".*/\1/g")
  RESOURCE_GROUP_NAME=$(grep -E "^resource_group_name" "${ENVIRONMENT_TFVARS}" | sed -E "s/^resource_group_name=\"(.*)\".*/\1/g")
  NAME_PREFIX=$(grep -E "^name_prefix" "${ENVIRONMENT_TFVARS}" | sed -E "s/^name_prefix=\"(.*)\".*/\1/g")
  CLUSTER_EXISTS=$(grep -E "^cluster_exists" "${ENVIRONMENT_TFVARS}" | sed -E "s/^cluster_exists=\"(.*)\".*/\1/g")
  CLUSTER_TYPE=$(grep -E "^cluster_type" "${ENVIRONMENT_TFVARS}" | sed -E "s/^cluster_type=\"(.*)\".*/\1/g")
  MANAGED_BY=" managed by \033[1;33mIBM Cloud\033[0m"

  if [[ -z "${CLUSTER_NAME}" ]]; then
    if [[ -n "${NAME_PREFIX}" ]]; then
      CLUSTER_NAME="${NAME_PREFIX}-cluster"
    else
      CLUSTER_NAME="${RESOURCE_GROUP_NAME}-cluster"
    fi

    WRITE_CLUSTER_NAME="true"
  fi
else
  ENVIRONMENT_TFVARS="${SRC_DIR}/settings/environment-ocp.tfvars"

  if [[ -f "${ENVIRONMENT_TFVARS}" ]]; then
    CLUSTER_NAME=$(grep -E "^cluster_name" "${ENVIRONMENT_TFVARS}" | sed -E "s/^cluster_name=\"(.*)\".*/\1/g")
    SERVER_URL=$(grep -E "^server_url" "${ENVIRONMENT_TFVARS}" | sed -E "s/^server_url=\"(.*)\".*/\1/g")
  fi

  if [[ -z "${CLUSTER_NAME}" ]]; then
    CLUSTER_NAME="ocp-cluster"
  fi

  if [[ -z "${SERVER_URL}" ]]; then
    SERVER_URL="${TF_VAR_server_url}"
  fi

  CLUSTER_EXISTS="true"
  CLUSTER_TYPE="ocp4"
fi

WORKSPACE_DIR="${SRC_DIR}/workspaces/${CLUSTER_NAME}"

if [[ -d "${WORKSPACE_DIR}" ]]; then
  echo -e "A workspace directory already exists for this cluster: \033[1;33m${CLUSTER_NAME}\033[0m"

  if [[ "${*:1}" =~ "--delete" ]] || [[ "${*:1}" =~ "-d" ]]; then
    ANSWER="d"
  elif [[ "${*:1}" =~ "--keep" ]] || [[ "${*:1}" =~ "-k" ]]; then
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

rm -f "${TFVARS}"

if [[ -f "${ENVIRONMENT_TFVARS}" ]]; then
  cat "${ENVIRONMENT_TFVARS}" >> "${TFVARS}"
fi
cat "${SRC_DIR}/settings/vlan.tfvars" >> "${TFVARS}"
echo "" >> "${TFVARS}"
cp "${SRC_DIR}"/scripts-workspace/* "${WORKSPACE_DIR}"

# Read terraform.tfvars to see if cluster_exists, postgres_server_exists, and cluster_type are set
# If not, get them from the user and write them to a file

if [[ -n "${WRITE_CLUSTER_NAME}" ]]; then
  echo "cluster_name=\"${CLUSTER_NAME}\"" >> "${TFVARS}"
fi

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

echo -e ""
echo -e "Terraform is about to run with the following settings:"
if [[ -n "${RESOURCE_GROUP_NAME}" ]]; then
  echo -e "  - Resource group \033[1;33m${RESOURCE_GROUP_NAME}\033[0m"
fi
if [[ "${CLUSTER_EXISTS}" == "false" ]]; then
    echo -e "  - Create a new \033[1;33m${CLUSTER_TYPE}\033[0m cluster instance named \033[1;33m${CLUSTER_NAME}\033[0m${MANAGED_BY}"
else
    if [[ -n "${SERVER_URL}" ]]; then
      echo -e "  - Use an existing \033[1;33m${CLUSTER_TYPE}\033[0m cluster instance at ${SERVER_URL}"
    else
      echo -e "  - Use an existing \033[1;33m${CLUSTER_TYPE}\033[0m cluster instance named \033[1;33m${CLUSTER_NAME}\033[0m${MANAGED_BY}"
    fi
    echo ""
    echo -e "\033[1;31mBefore configuring the environment the following namespaces and their contents will be destroyed: tools and ibm-observe\033[0m"
fi

if [[ "o" == "${CLUSTER_MANAGEMENT}" ]]; then
	STAGES_DIRECTORY="stages-ocp4"
else
	STAGES_DIRECTORY="stages"
fi

cp "${SRC_DIR}/${STAGES_DIRECTORY}/variables.tf" "${WORKSPACE_DIR}"
cp "${SRC_DIR}/${STAGES_DIRECTORY}"/stage*.tf "${WORKSPACE_DIR}"

echo ""

if [[ ! "${*:1}" =~ "--auto-approve" ]] && [[ !  "${*:1}" =~ "-a" ]]; then
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
