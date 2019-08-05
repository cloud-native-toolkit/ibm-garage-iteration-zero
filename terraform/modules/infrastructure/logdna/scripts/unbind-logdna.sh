defdd#!/usr/bin/env bash

NAMESPACE="$1"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
   export KUBECONFIG="${KUBECONFIG_IKS}"
fi

echo "*** Creating logdna-agent-key secret in ${NAMESPACE}"
kubectl delete -n ${NAMESPACE} secret/logdna-agent-key

echo "*** Creating logdna-agent daemon set in ${NAMESPACE}"
kubectl delete -n ${NAMESPACE} ds/logdna-agent
