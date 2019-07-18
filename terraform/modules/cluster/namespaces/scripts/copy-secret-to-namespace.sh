#!/usr/bin/env bash

print_usage() {
    echo "Missing required arguments"
    echo "Usage: $0 {SECRET_NAME} {TO_NAMESPACE} [{FROM_NAMESPACE}]"
}

if [[ -z "$1" ]]; then
    print_usage
    exit 1
else
   SECRET_NAME="$1"
fi

if [[ -z "$2" ]]; then
    print_usage
    exit 1
else
   TO_NAMESPACE="$2"
fi

if [[ -z "$3" ]]; then
   FROM_NAMESPACE="default"
else
   FROM_NAMESPACE="$3"
fi

if [[ -z "${KUBECONFIG}" ]]; then
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

kubectl get secret ${SECRET_NAME} --namespace ${FROM_NAMESPACE} 1> /dev/null 2> /dev/null
if [[ $? -ne 0 ]]; then
  echo "*** ${SECRET_NAME} could not be found in ${FROM_NAMESPACE} namespace"
  exit 0
fi

if [[ $(kubectl get secrets -n "${TO_NAMESPACE}" -o jsonpath='{ range .items[*] }{ .metadata.name }{ "\n" }{ end }' | grep ${SECRET_NAME} | wc -l | xargs) -eq 0 ]]; then
    echo "*** Copying ${SECRET_NAME} from ${FROM_NAMESPACE} namespace to ${TO_NAMESPACE} namespace"

    kubectl get secret ${SECRET_NAME} --namespace=${FROM_NAMESPACE} -oyaml | sed "s/namespace: ${FROM_NAMESPACE}/namespace: ${TO_NAMESPACE}/g" | kubectl apply --namespace=${TO_NAMESPACE} -f -
else
    echo "*** ${SECRET_NAME} already exists in ${TO_NAMESPACE} namespace"
fi
