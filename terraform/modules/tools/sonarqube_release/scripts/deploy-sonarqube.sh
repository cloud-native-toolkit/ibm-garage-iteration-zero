#!/usr/bin/env bash

#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P);

SONARQUBE_SECRET_CHART="$1"
NAMESPACE="$2"
SONARQUBE_HOST="$3"
VALUES_FILE="$4"
KUSTOMIZE_TEMPLATE="$5"
VERSION="$6"
SERVICE_ACCOUNT="$7"
PLUGINS="$8"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

if [[ -z "${TMP_DIR}" ]]; then
    TMP_DIR=".tmp"
fi
if [[ -z "${CHART_REPO}" ]]; then
    CHART_REPO="https://kubernetes-charts.storage.googleapis.com/"
fi

NAME="sonarqube"

CHART_DIR="${TMP_DIR}/charts"
KUSTOMIZE_DIR="${TMP_DIR}/kustomize"

SONARQUBE_CHART="${CHART_DIR}/sonarqube"

SONARQUBE_KUSTOMIZE="${KUSTOMIZE_DIR}/sonarqube"
SONARQUBE_BASE_KUSTOMIZE="${SONARQUBE_KUSTOMIZE}/base.yaml"
SONARQUBE_SECRET_KUSTOMIZE="${SONARQUBE_KUSTOMIZE}/secret.yaml"
PATCH_DEPLOYMENT_KUSTOMIZE="${SONARQUBE_KUSTOMIZE}/patch-deployment.yaml"

PATCH_DEPLOYMENT_TEMPLATE="${KUSTOMIZE_TEMPLATE}/patch-deployment.yaml"

SONARQUBE_YAML="${TMP_DIR}/sonarqube.yaml"

echo "*** Fetching Sonarqube helm chart from ${CHART_REPO} into ${CHART_DIR}"
mkdir -p "${CHART_DIR}"
helm fetch --repo "${CHART_REPO}" --untar --untardir "${CHART_DIR}" --version "${VERSION}" sonarqube

echo "*** Setting up kustomize directory"
mkdir -p "${KUSTOMIZE_DIR}"
cp -R "${KUSTOMIZE_TEMPLATE}" "${KUSTOMIZE_DIR}"

echo "*** Updating patch-deployment.yaml with service account"
cat "${PATCH_DEPLOYMENT_TEMPLATE}" | sed "s/%SERVICE_ACCOUNT_NAME%/${SERVICE_ACCOUNT}/g" > ${PATCH_DEPLOYMENT_KUSTOMIZE}

echo "*** Cleaning up helm chart tests"
rm "${SONARQUBE_CHART}/templates/sonarqube-test.yaml"
rm "${SONARQUBE_CHART}/templates/test-config.yaml"

PLUGIN_YAML=$(echo $PLUGINS | sed -E "s/[[](.*)[]]/{\1}/g")

echo "*** Generating sonarqube yaml from helm template with plugins ${PLUGIN_YAML}"
helm init --client-only
helm template "${SONARQUBE_CHART}" \
    --namespace "${NAMESPACE}" \
    --name "${NAME}" \
    --set ingress.hosts.0.name="${SONARQUBE_HOST}" \
    --set postgresql.postgresServer="${DATABASE_HOST}" \
    --set postgresql.service.port="${DATABASE_PORT}" \
    --set postgresql.postgresDatabase="${DATABASE_NAME}" \
    --set postgresql.postgresUser="${DATABASE_USERNAME}" \
    --set postgresql.postgresPassword="${DATABASE_PASSWORD}" \
    --set plugins.install=${PLUGIN_YAML} \
    --values "${VALUES_FILE}" > "${SONARQUBE_BASE_KUSTOMIZE}"

echo "*** Generating sonarqube-secret yaml from helm template"
helm template "${SONARQUBE_SECRET_CHART}" \
    --namespace "${NAMESPACE}" \
    --set url="${SONARQUBE_HOST}" > "${SONARQUBE_SECRET_KUSTOMIZE}"

echo "*** Building final kube yaml from kustomize into ${SONARQUBE_YAML}"
kustomize build "${SONARQUBE_KUSTOMIZE}" > "${SONARQUBE_YAML}"

echo "*** Applying Sonarqube yaml to kube"
kubectl apply -n "${NAMESPACE}" -f "${SONARQUBE_YAML}"

echo "*** Waiting for Sonarqube"
until ${SCRIPT_DIR}/checkPodRunning.sh sonarqube-sonarqube; do
    echo '>>> waiting for Sonarqube'
    sleep 300
done
echo '>>> Sonarqube has started'
