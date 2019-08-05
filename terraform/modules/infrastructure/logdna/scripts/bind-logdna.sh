#!/usr/bin/env bash

NAMESPACE="$1"
LOGDNA_AGENT_KEY="$2"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
   export KUBECONFIG="${KUBECONFIG_IKS}"
fi

if [[ -z "${TMP_DIR}" ]]; then
   TMP_DIR=".tmp"
fi

mkdir -p ${TMP_DIR}
YAML_FILE=${TMP_DIR}/logdna-agent-key.yaml

cat << 'EOF' >> ${YAML_FILE}
apiVersion: v1
kind: Secret
metadata:
  name: logdna-agent-key
type: Opaque
stringData:
  logdna-agent-key: ${LOGDNA_AGENT_KEY}
EOF

echo "*** Creating logdna-agent-key secret in ${NAMESPACE}"
kubectl apply -n ${NAMESPACE} -f ${YAML_FILE}

echo "*** Creating logdna-agent daemon set in ${NAMESPACE}"
kubectl apply -n ${NAMESPACE} -f https://assets.us-south.logging.cloud.ibm.com/clients/logdna-agent-ds.yaml
