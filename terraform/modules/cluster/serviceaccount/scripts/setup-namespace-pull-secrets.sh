#!/usr/bin/env bash

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
else
  if [[ -z "${CLUSTER_NAME}" ]]; then
    if [[ -z "${RESOURCE_GROUP}" ]]; then
      RESOURCE_GROUP=$(ibmcloud target | grep "Resource group" | sed -E "s/Resource group: +([^ ]+) +/\1/g")
    fi

    CLUSTER_NAME="${RESOURCE_GROUP}-cluster"
  fi
fi

if [[ -z "$1" ]]; then
   echo "CLUSTER_NAMESPACE should be provided as first argument"
   exit 1
else
   CLUSTER_NAMESPACE="$1"
fi

if [[ $(kubectl get secrets -n "${CLUSTER_NAMESPACE}" -o jsonpath='{ range .items[*] }{ .metadata.name }{ "\n" }{ end }' | grep icr | wc -l | xargs) -eq 0 ]]; then
    echo "*** Copying pull secrets from default namespace to ${CLUSTER_NAMESPACE} namespace"

    kubectl get secrets -n default | grep icr | sed "s/\([A-Za-z-]*\) *.*/\1/g" | while read default_secret; do
        kubectl get secret ${default_secret} -o yaml | sed "s/namespace: default/namespace: ${CLUSTER_NAMESPACE}/g" | sed "s/name: default/name: ${CLUSTER_NAMESPACE}/g" | kubectl -n ${CLUSTER_NAMESPACE} create -f -
        kubectl get secret ${default_secret} -o yaml | sed "s/namespace: default/namespace: ${CLUSTER_NAMESPACE}/g" | sed "s/name: default-/name: /g" | kubectl -n ${CLUSTER_NAMESPACE} create -f -
    done
else
    echo "*** Pull secrets already exist on ${CLUSTER_NAMESPACE} namespace"
fi


EXISTING_SECRETS=$(kubectl describe serviceaccount/default -n "${CLUSTER_NAMESPACE}" | grep "Image pull secrets:" | sed -E "s/Image pull secrets: +([^ ]+) */\1/g")
if [[ "${EXISTING_SECRETS}" == "<none>" ]]; then
    echo "*** Adding secrets to serviceaccount/default in ${CLUSTER_NAMESPACE} namespace"

    PULL_SECRETS=$(kubectl get secrets -n "${CLUSTER_NAMESPACE}" -o jsonpath='{ range .items[*] }{ "{\"name\": \""}{ .metadata.name }{ "\"}\n" }{ end }' | grep icr | grep -v "${CLUSTER_NAMESPACE}" | paste -sd "," -)
    kubectl patch -n "${CLUSTER_NAMESPACE}" serviceaccount/default -p "{\"imagePullSecrets\": [${PULL_SECRETS}]}"
else
    echo "*** Pull secrets already applied to serviceaccount/default in ${CLUSTER_NAMESPACE} namespace"
fi
