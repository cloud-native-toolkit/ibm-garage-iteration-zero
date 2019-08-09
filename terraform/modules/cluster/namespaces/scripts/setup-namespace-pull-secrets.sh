#!/usr/bin/env bash

CLUSTER_NAME="$1"
if [[ -z "${CLUSTER_NAME}" ]]; then
   echo "CLUSTER_NAME should be provided as first argument"
   exit 1
fi

CLUSTER_NAMESPACE="$2"
if [[ -z "${CLUSTER_NAMESPACE}" ]]; then
   echo "CLUSTER_NAMESPACE should be provided as second argument"
   exit 1
fi

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

if [[ $(kubectl get secrets -n "${CLUSTER_NAMESPACE}" -o jsonpath='{ range .items[*] }{ .metadata.name }{ "\n" }{ end }' | grep icr | wc -l | xargs) -eq 0 ]]; then
    echo "*** Copying pull secrets from default namespace to ${CLUSTER_NAMESPACE} namespace"

    kubectl get secrets -n default | grep icr | sed "s/\([A-Za-z-]*\) *.*/\1/g" | while read default_secret; do
        kubectl get secret ${default_secret} -n default -o yaml | sed "s/namespace: default/namespace: ${CLUSTER_NAMESPACE}/g" | sed "s/name: default/name: ${CLUSTER_NAMESPACE}/g" | kubectl -n ${CLUSTER_NAMESPACE} create -f -
        kubectl get secret ${default_secret} -n default -o yaml | sed "s/namespace: default/namespace: ${CLUSTER_NAMESPACE}/g" | sed "s/name: default-/name: /g" | kubectl -n ${CLUSTER_NAMESPACE} create -f -
    done
else
    echo "*** Pull secrets already exist on ${CLUSTER_NAMESPACE} namespace"
fi


EXISTING_SECRETS=$(kubectl get serviceaccount/default -n "${CLUSTER_NAMESPACE}" -o json  | tr '\n' ' ' | sed -E "s/.*imagePullSecrets.: \[([^]]*)\].*/\1/g" | grep icr | wc -l | xargs)
if [[ ${EXISTING_SECRETS} -eq 0 ]]; then
    echo "*** Adding secrets to serviceaccount/default in ${CLUSTER_NAMESPACE} namespace"

    PULL_SECRETS=$(kubectl get secrets -n "${CLUSTER_NAMESPACE}" -o jsonpath='{ range .items[*] }{ "{\"name\": \""}{ .metadata.name }{ "\"}\n" }{ end }' | grep icr | grep -v "${CLUSTER_NAMESPACE}" | paste -sd "," -)
    kubectl patch -n "${CLUSTER_NAMESPACE}" serviceaccount/default -p "{\"imagePullSecrets\": [${PULL_SECRETS}]}"
else
    echo "*** Pull secrets already applied to serviceaccount/default in ${CLUSTER_NAMESPACE} namespace"
fi
