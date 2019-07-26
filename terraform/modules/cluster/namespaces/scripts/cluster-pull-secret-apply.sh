#!/usr/bin/env bash

CLUSTER_NAME="$1"
if [[ -z "${CLUSTER_NAME}" ]]; then
    echo "CLUSTER_NAME should be the first argument"
    exit 1
fi

if [[ $(kubectl get secrets -n default -o jsonpath='{ range .items[*] }{ .metadata.name }{ "\n" }{ end }' | grep icr | wc -l | xargs) -eq 0 ]]; then
    echo "Applying pull secrets to default namespace of cluster: ${CLUSTER_NAME}"

    ibmcloud ks cluster-pull-secret-apply --cluster "${CLUSTER_NAME}"
else
    echo "Nothing to do... Secrets already applied to default namespace of cluster: ${CLUSTER_NAME}"
fi
