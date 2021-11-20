#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

export KUBECONFIG="${cat .kubeconfig}"

set -e

kubectl get pods -A

kubectl get cm cloud-config -n default

exit 0
