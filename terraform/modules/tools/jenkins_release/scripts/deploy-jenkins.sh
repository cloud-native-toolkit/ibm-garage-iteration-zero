#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P);

JENKINS_CONFIG_CHART="$1"
NAMESPACE="$2"
JENKINS_HOST="$3"
VALUES_FILE="$4"
KUSTOMIZE_TEMPLATE="$5"

if [[ -z "${TMP_DIR}" ]]; then
    TMP_DIR=".tmp"
fi
if [[ -z "${CHART_REPO}" ]]; then
    CHART_REPO="https://kubernetes-charts.storage.googleapis.com/"
fi

NAME="jenkins"

CHART_DIR="${TMP_DIR}/charts"
KUSTOMIZE_DIR="${TMP_DIR}/kustomize"

JENKINS_CHART="${CHART_DIR}/jenkins"

JENKINS_KUSTOMIZE="${KUSTOMIZE_DIR}/jenkins"
JENKINS_BASE_KUSTOMIZE="${JENKINS_KUSTOMIZE}/base.yaml"
JENKINS_CONFIG_KUSTOMIZE="${JENKINS_KUSTOMIZE}/jenkins-config.yaml"

JENKINS_YAML="${TMP_DIR}/jenkins.yaml"

echo "*** Fetching Jenkins helm chart from ${CHART_REPO} into ${CHART_DIR}"
mkdir -p "${CHART_DIR}"
helm fetch --repo "${CHART_REPO}" --untar --untardir "${CHART_DIR}" jenkins

echo "*** Setting up kustomize directory"
mkdir -p "${KUSTOMIZE_DIR}"
cp -R "${KUSTOMIZE_TEMPLATE}" "${KUSTOMIZE_DIR}"

echo "*** Cleaning up helm chart tests"
rm -rf "${JENKINS_CHART}/templates/tests"

echo "*** Generating jenkins yaml from helm template"
helm init --client-only
helm template "${JENKINS_CHART}" \
    --namespace "${NAMESPACE}" \
    --name "${NAME}" \
    --set master.ingress.hostName="${JENKINS_HOST}" \
    --values "${VALUES_FILE}" > "${JENKINS_BASE_KUSTOMIZE}"

echo "*** Generating jenkins-config yaml from helm template"
helm template "${JENKINS_CONFIG_CHART}" \
    --namespace "${NAMESPACE}" \
    --set jenkins.host="${JENKINS_HOST}" > "${JENKINS_CONFIG_KUSTOMIZE}"

echo "*** Building final kube yaml from kustomize into ${JENKINS_YAML}"
kustomize build "${JENKINS_KUSTOMIZE}" > "${JENKINS_YAML}"

echo "*** Applying Jenkins yaml to kube"
kubectl apply -n "${NAMESPACE}" -f "${JENKINS_YAML}"

echo "*** Waiting for Jenkins"
until ${SCRIPT_DIR}/checkPodRunning.sh jenkins; do
    echo '>>> waiting for Jenkins'
    sleep 300
done
echo '>>> Jenkins has started'
