#!/bin/bash
TEAM_NUMBER=$1
cat rbac-roles.yaml | sed "s/#MOOC-TEAM/#MOOC-TEAM-${TEAM_NUMBER}/g" | kubectl apply -f -
