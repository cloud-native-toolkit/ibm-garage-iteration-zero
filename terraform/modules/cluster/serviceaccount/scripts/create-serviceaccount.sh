#!/usr/bin/env bash

NAMESPACE="$1"
SERVICE_ACCOUNT_NAME="$2"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

kubectl create serviceaccount -n ${NAMESPACE} ${SERVICE_ACCOUNT_NAME}
