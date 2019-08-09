#!/usr/bin/env bash

NAMESPACE="$1"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

echo "creating namespace ${NAMESPACE}"
kubectl create namespace "${NAMESPACE}"
