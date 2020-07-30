#!/usr/bin/env bash

USER_EMAIL="$1"
GROUP_NAME="$2"

USER_ID="IAM#${USER_EMAIL}"

if [[ -z "${GROUP_NAME}}" ]]; then
  GROUP_NAME="cluster-users"
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "Checking if user exists: ${YELLOW}${USER_ID}${NC}"
if kubectl get user "${USER_ID}" 1> /dev/null 2> /dev/null; then
  echo -e "   User exists in cluster. Checking that user is not already in the group: ${YELLOW}${GROUP_NAME}${NC}"
  if kubectl get group "${GROUP_NAME}" -o jsonpath='{.users}' | grep -q "${USER_ID}"; then
    echo -e "   ${GREEN}The user has already been added to the group${NC}"
    exit 0
  fi

  kubectl patch group "${GROUP_NAME}" --type json -p="[{\"op\": \"add\", \"path\": \"/users/-\", \"value\": \"${USER_ID}\"}]"
else
  echo -e "${RED}User cannot be found:${NC} ${YELLOW}${USER_ID}${NC}"
  echo -e "  Have the user log into the cluster and try again"
fi
