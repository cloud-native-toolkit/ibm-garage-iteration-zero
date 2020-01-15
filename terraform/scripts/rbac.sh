#!/bin/bash
TEAM_NAME=$1
cat rbac-roles.yaml | sed "s/#RG-TEAM/#${TEAM_NAME}/g" | kubectl apply -f -
