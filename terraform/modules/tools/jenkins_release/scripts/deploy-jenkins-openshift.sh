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
