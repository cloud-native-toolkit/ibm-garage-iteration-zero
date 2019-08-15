#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

NAMESPACE="$1"
STORAGE_CLASS="$2"
VOLUME_CAPACITY="$3"

oc new-app jenkins-persistent -n "${NAMESPACE}" \
    -e STORAGE_CLASS="${STORAGE_CLASS}" \
    -e VOLUME_CAPACITY="${VOLUME_CAPACITY}"

until ${SCRIPT_DIR}/checkPodRunning.sh jenkins; do
    echo '>>> waiting for Jenkins'
    sleep 300
done
echo '>>> Jenkins has started'

JENKINS_HOST=$(oc get route jenkins -n ${NAMESPACE} -o jsonpath='{ .spec.host }')
oc create secret generic jenkins-access -n ${NAMESPACE} --from-literal url=https://${JENKINS_HOST}
oc create configmap jenkins-connfig -n ${NAMESPACE} --from-literal JENKINS_URL=https://${JENKINS_HOST}
