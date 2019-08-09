#!/usr/bin/env bash

NAMESPACE="$1"
SERVICE_ACCOUNT_NAME="$2"

oc delete serviceaccount -n ${NAMESPACE} ${SERVICE_ACCOUNT_NAME}
exit 0
