#!/usr/bin/env bash

SCRIPT_DIR="$(cd $(dirname $0); pwd -P)"
LOCAL_CHART_DIR=$(cd "${SCRIPT_DIR}/../charts"; pwd -P)
LOCAL_KUSTOMIZE_DIR=$(cd "${SCRIPT_DIR}/../kustomize"; pwd -P)

NAMESPACE="$1"
INGRESS_HOST="$2"
VALUES_FILE="$3"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

if [[ -z "${TMP_DIR}" ]]; then
    TMP_DIR=".tmp"
fi
if [[ -z "${CHART_REPO}" ]]; then
    CHART_REPO="https://charts.jfrog.io"
fi

CHART_DIR="${TMP_DIR}/charts"
KUSTOMIZE_DIR="${TMP_DIR}/kustomize"


KUSTOMIZE_TEMPLATE="${LOCAL_KUSTOMIZE_DIR}/artifactory"

ARTIFACTORY_CHART="${CHART_DIR}/artifactory"
SECRET_CHART="${LOCAL_CHART_DIR}/artifactory-access"

ARTIFACTORY_KUSTOMIZE="${KUSTOMIZE_DIR}/artifactory"


NAME="artifactory"
ARTIFACTORY_OUTPUT_YAML="${ARTIFACTORY_KUSTOMIZE}/base.yaml"
SECRET_OUTPUT_YAML="${ARTIFACTORY_KUSTOMIZE}/secret.yaml"

OUTPUT_YAML="${TMP_DIR}/artifactory.yaml"

echo "*** Setting up kustomize directory"
mkdir -p "${KUSTOMIZE_DIR}"
cp -R "${KUSTOMIZE_TEMPLATE}" "${KUSTOMIZE_DIR}"

echo "*** Fetching helm chart from ${CHART_REPO}"
mkdir -p ${CHART_DIR}
helm init --client-only
helm fetch --repo "${CHART_REPO}" --untar --untardir "${CHART_DIR}" artifactory

echo "*** Generating kube yaml from helm template into ${ARTIFACTORY_OUTPUT_YAML}"
helm template "${ARTIFACTORY_CHART}" \
    --namespace "${NAMESPACE}" \
    --name "artifactory" \
    --set "ingress.hosts.0=${INGRESS_HOST}" \
    --values "${VALUES_FILE}" > "${ARTIFACTORY_OUTPUT_YAML}"

echo "*** Generating artifactory-access yaml from helm template into ${SECRET_OUTPUT_YAML}"
helm template "${SECRET_CHART}" \
    --namespace "${NAMESPACE}" \
    --set url="http://${INGRESS_HOST}" > "${SECRET_OUTPUT_YAML}"

echo "*** Building final kube yaml from kustomize into ${OUTPUT_YAML}"
kustomize build "${ARTIFACTORY_KUSTOMIZE}" > "${OUTPUT_YAML}"

echo "*** Applying kube yaml ${ARTIFACTORY_OUTPUT_YAML}"
kubectl apply -n "${NAMESPACE}" -f "${OUTPUT_YAML}"
