#!/usr/bin/env bash

NAME="$1"
SKIP_LOGIN="$2"

if [[ -z "${NAME}" ]]; then
    echo "NAME not provided"
    exit 1
fi

if [[ "${NAME}" == "--help" ]]; then
    echo "Usage: ${0} {POD_NAME}"
    exit 1
fi

if [[ -z "${NAMESPACE}" ]]; then
    NAMESPACE="tools"
fi

if [[ -z "${KUBECONFIG}" ]] && [[ -z "${SKIP_LOGIN}" ]]; then
  if [[ -z "${APIKEY}" ]] || [[ -z "${RESOURCE_GROUP}" ]] || [[ -z "${REGION}" ]]; then
    echo "Either KUBECONFIG or APIKEY, RESOURCE_GROUP, and REGION are required"
    exit 1
  fi

  if [[ -z "${CLUSTER_NAME}" ]]; then
    CLUSTER_NAME="${RESOURCE_GROUP}-cluster"
  fi

  if [[ -z "${TMP_DIR}" ]]; then
    TMP_DIR="./.tmp"
  fi

  mkdir -p "${TMP_DIR}"

  ibmcloud config --check-version=false 1> /dev/null 2> /dev/null

  echo "Logging into ibmcloud cluster: ${REGION}/${RESOURCE_GROUP}/${CLUSTER_NAME}"
  ibmcloud login --apikey ${APIKEY} -g ${RESOURCE_GROUP} -r ${REGION} 1> /dev/null 2> /dev/null
  ibmcloud ks cluster-config --cluster ${CLUSTER_NAME} --export > ${TMP_DIR}/.kubeconfig

  source ${TMP_DIR}/.kubeconfig
fi

POD_NAME=$(kubectl get pods -n ${NAMESPACE} | grep -m 1 "${NAME}" | sed -E "s/([a-zA-Z0-9-]+) +.*/\1/g")

STATUS=$(kubectl get pod/${POD_NAME} -n ${NAMESPACE} -o jsonpath="{ .status.phase }")

if [[ "Running" == "${STATUS}" ]]; then
    exit 0
else
    exit 1
fi
