#!/usr/bin/env bash

CHART="$1"
NAMESPACE="$2"
INGRESS_HOST="$4"
JENKINS_SECRET="$5"
SONARQUBE_SECRET="$6"
PACTBROKER_SECRET="$7"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

if [[ -z "${TMP_DIR}" ]]; then
    TMP_DIR=".tmp"
fi

NAME="catalyst-dashboard"
OUTPUT_YAML="${TMP_DIR}/catalystdashboard.yaml"

mkdir -p ${TMP_DIR}

echo "*** Generating kube yaml from helm template into ${OUTPUT_YAML}"
helm init --client-only
helm template ${CHART} \
    --namespace ${NAMESPACE} \
    --name ${NAME} \
    --set ingress.hosts.0=${INGRESS_HOST} \
    --set secrets.jenkins=${JENKINS_SECRET} \
    --set secrets.sonarqube=${SONARQUBE_SECRET} \
    --set secrets.pactbroker=${PACTBROKER_SECRET} > ${OUTPUT_YAML}

echo "*** Applying kube yaml ${OUTPUT_YAML}"
kubectl apply -n ${NAMESPACE} -f ${OUTPUT_YAML}
