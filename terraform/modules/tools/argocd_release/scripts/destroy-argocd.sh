#!/usr/bin/env bash

NAMESPACE="$1"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

kubectl delete all -n "${NAMESPACE}" -l app=argocd
