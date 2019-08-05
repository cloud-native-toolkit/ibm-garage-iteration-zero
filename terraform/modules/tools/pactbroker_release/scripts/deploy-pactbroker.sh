#!/usr/bin/env bash

CHART="$1"
NAMESPACE="$2"
INGRESS_HOST="$3"
DATABASE_TYPE="$4"
DATABASE_NAME="$5"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

if [[ -z "${TMP_DIR}" ]]; then
    TMP_DIR=".tmp"
fi

NAME="pact-broker"
OUTPUT_YAML="${TMP_DIR}/pactbroker.yaml"

mkdir -p ${TMP_DIR}

echo "*** Generating kube yaml from helm template into ${OUTPUT_YAML}"
helm init --client-only
helm template ${CHART} \
    --namespace ${NAMESPACE} \
    --name ${NAME} \
    --set ingress.hosts.0.host=${INGRESS_HOST} \
    --set database.type=${DATABASE_TYPE} \
    --set database.name=${DATABASE_NAME} > ${OUTPUT_YAML}

echo "*** Applying kube yaml ${OUTPUT_YAML}"
kubectl apply -n ${NAMESPACE} -f ${OUTPUT_YAML}
