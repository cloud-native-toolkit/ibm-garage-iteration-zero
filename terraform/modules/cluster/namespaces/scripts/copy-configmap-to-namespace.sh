#!/usr/bin/env bash

print_usage() {
    echo "Missing required arguments"
    echo "Usage: $0 {SECRET_NAME} {TO_NAMESPACE} [{FROM_NAMESPACE}]"
}

if [[ -z "$1" ]]; then
    print_usage
    exit 1
else
   CONFIGMAP_NAME="$1"
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

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

kubectl get configmap ${CONFIGMAP_NAME} --namespace ${FROM_NAMESPACE} 1> /dev/null 2> /dev/null
if [[ $? -ne 0 ]]; then
  echo "*** ${CONFIGMAP_NAME} could not be found in ${FROM_NAMESPACE} namespace"
  exit 0
fi

if [[ $(kubectl get secrets -n "${TO_NAMESPACE}" -o jsonpath='{ range .items[*] }{ .metadata.name }{ "\n" }{ end }' | grep ${CONFIGMAP_NAME} | wc -l | xargs) -eq 0 ]]; then
    echo "*** Copying ${CONFIGMAP_NAME} from ${FROM_NAMESPACE} namespace to ${TO_NAMESPACE} namespace"

    kubectl get configmap ${CONFIGMAP_NAME} --namespace=${FROM_NAMESPACE} -oyaml | sed "s/namespace: ${FROM_NAMESPACE}/namespace: ${TO_NAMESPACE}/g" | kubectl apply --namespace=${TO_NAMESPACE} -f -
else
    echo "*** ${CONFIGMAP_NAME} already exists in ${TO_NAMESPACE} namespace"
fi
