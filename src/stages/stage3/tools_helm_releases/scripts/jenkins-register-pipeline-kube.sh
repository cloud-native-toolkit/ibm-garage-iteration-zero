#!/usr/bin/env bash

SCRIPT_ROOT=$(dirname $0)

JENKINS_NAMESPACE="$1"
JENKINS_ACCESS_SECRET="$2"
GIT_CREDENTIALS="$3"

if [[ -z "${JENKINS_NAMESPACE}" ]] || [[ -z "${JENKINS_ACCESS_SECRET}" ]] || [[ -z "${GIT_CREDENTIALS}" ]]; then
    echo -e "Pipeline registration script is missing required fields"
    echo -e "Usage: $0 {JENKINS_NAMESPACE} {JENKINS_ACCESS_SECRET} {GIT_CREDENTIALS} [{GIT_BRANCH}] [{CONFIG_FILE}]"
    echo -e "  where:"
    echo -e "    JENKINS_NAMESPACE - the kubernetes namespace where Jenkins is deployed"
    echo -e "    JENKINS_ACCESS_SECRET - the name of the secret in kubernetes that has the Jenkins access information (username, password, url)"
    echo -e "    GIT_CREDENTIALS - the name of the secret in kubernetes that has the Git credentials and url"
    echo -e "    GIT_BRANCH - (optional) the branch that should be registered for the build. Defaults to 'master'"
    echo -e "    CONFIG_FILE - (optional) the file containing the pipeline config. Defaults to 'config-template.xml'"
    echo -e "  note:"
    echo -e "    This script uses kubectl to read secrets from kubernetes. It expects the kubernetes environment to have"
    echo -e "    been initialized (e.g. ibmcloud login && ibmcloud ks config-cluster)"
    echo -e ""
    exit 1
fi

JENKINS_HOST=$(kubectl get secret --namespace ${JENKINS_NAMESPACE} ${JENKINS_ACCESS_SECRET} -o jsonpath="{.data.url}" | base64 --decode)
USER_NAME=$(kubectl get secret --namespace ${JENKINS_NAMESPACE} ${JENKINS_ACCESS_SECRET} -o jsonpath="{.data.username}" | base64 --decode)
API_TOKEN=$(kubectl get secret --namespace ${JENKINS_NAMESPACE} ${JENKINS_ACCESS_SECRET} -o jsonpath="{.data.password}" | base64 --decode)

GIT_REPO=$(kubectl get secret --namespace ${JENKINS_NAMESPACE} ${GIT_CREDENTIALS} -o jsonpath="{.data.url}" | base64 --decode)

GIT_BRANCH="master"
CONFIG_FILE="config-template.xml"

if [[ -z "$4" ]]; then
    GIT_BRANCH="$4"
fi
if [[ -z "$5" ]]; then
    CONFIG_FILE="$5"
fi

${SCRIPT_ROOT}/jenkins-register-pipeline.sh "${JENKINS_HOST}" "${USER_NAME}" "${API_TOKEN}" "${GIT_REPO}" "${GIT_CREDENTIALS}" "${GIT_BRANCH}" "${CONFIG_FILE}"
