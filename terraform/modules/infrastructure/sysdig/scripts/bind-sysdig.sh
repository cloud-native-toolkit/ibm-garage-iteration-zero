#!/usr/bin/env bash

ACCESS_KEY="$1"
ENDPOINT="$2"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
   export KUBECONFIG="${KUBECONFIG_IKS}"
else
   OPENSHIFT="-op"
fi

echo "*** Binding sysdig to cluster using endpoint ${ENDPOINT}"

curl -sL https://ibm.biz/install-sysdig-k8s-agent | bash -s -- -a ${ACCESS_KEY} -c ${ENDPOINT} ${OPENSHIFT} -ac 'sysdig_capture_enabled: false'
