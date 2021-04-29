#!/bin/bash
###################################################################################
# Register a collection of IBM Cloud Private Catalog Offerings within an Existing
# Catalog
#
# Author : Matthew Perrins, Sean Sundberg
# email  : mjperrin@us.ibm.com, seansund@us.ibm.com
#
###################################################################################
echo "IBM Cloud Private Catalog Offering Creation!"
echo ""
echo "This will create or update a set of offering tiles in an existing catalog."
echo "  CATALOG_NAME, API_KEY, GIT_REPO, VERSION, and OFFERINGS can all be provided via environment variables"
echo ""

# CATALOG_NAME input
if [[ -z "${CATALOG_NAME}" ]]; then
  read -rp "Please provide the CATALOG_NAME: " CATALOG_NAME

  if [[ -n "${CATALOG_NAME}" ]]; then
    echo ""
  fi
else
  echo "Using CATALOG_NAME: ${CATALOG_NAME}"
fi

while [[ -z "${CATALOG_NAME}" ]]; do
  read -rp "  The CATALOG_NAME cannot be empty. Try again: " CATALOG_NAME

  if [[ -n "${CATALOG_NAME}" ]]; then
    echo ""
  fi
done

# input validation
if [[ -z "${API_KEY}" ]]; then
  read -rsp "Please provide your API_KEY: " API_KEY
  echo ""

  if [[ -n "${API_KEY}" ]]; then
    echo ""
  fi
fi

while [[ -z "${API_KEY}" ]]; do
  read -rsp "  The API_KEY cannot be empty. Try again: " API_KEY
  echo ""

  if [[ -n "${API_KEY}" ]]; then
    echo ""
  fi
done

if [[ -z "${GIT_REPO}" ]]; then
  GIT_REPO="cloud-native-toolkit/ibm-garage-iteration-zero"
fi

echo "Using GIT_REPO: ${GIT_REPO}"

# input validation, Version is provided when the packaged release of this repository is created
if [[ -z "${VERSION}" ]]; then
  VERSION="latest"
fi

echo "Using VERSION: ${VERSION}"

if [[ "${VERSION}" == "latest" ]] || [[ -z "${OFFERINGS}" ]]; then
  echo "Retrieving version and offerings"

  if [[ "${VERSION}" == "latest" ]]; then
    RELEASE_URL="https://api.github.com/repos/${GIT_REPO}/releases/latest"
  else
    RELEASE_URL="https://api.github.com/repos/${GIT_REPO}/releases/tags/${VERSION}"
  fi

  RELEASE_JSON=$(curl -sL "${RELEASE_URL}" | jq -c '{tag_name, assets}')

  if [[ "${VERSION}" == "latest" ]]; then
    VERSION=$(echo "${RELEASE_JSON}" | jq -r '.tag_name')
    echo "  The latest version is $VERSION"
  fi

  if [[ -z "${OFFERINGS}" ]]; then
    OFFERINGS=$(echo "$RELEASE_JSON" | jq -r '.assets | .[] | .name' | grep -E "offering-.*json" | sed -E "s/.json$//g" | paste -sd "," -)

    echo "  Found offerings: ${OFFERINGS}"
  fi
fi

# Get a Bearer Token from IBM Cloud IAM
IAM_AUTH=$(curl -s -k -X POST \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --header "Accept: application/json" \
  --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
  --data-urlencode "apikey=${API_KEY}" \
  "https://iam.cloud.ibm.com/identity/token")

# Extract the Bearer Token from IAM response
TOKEN=$(echo "${IAM_AUTH}" |  jq '.access_token' | tr -d '"')
BEARER_TOKEN="Bearer ${TOKEN}"

# credentials to post data to cloudant for bulk document upload
ACURL="curl -s -g -H 'Authorization: ${BEARER_TOKEN}' -H 'Content-Type: application/json'"
HOST="https://cm.globalcatalog.cloud.ibm.com/api/v1-beta"

TMP_DIR="./offerings-tmp"
if ! mkdir -p "${TMP_DIR}"; then
  echo "Error creating tmp dir: ${TMP_DIR}"
  exit 1
fi

# Get List of Catalogs and match to Catalog name
# If the catalog does not exist create it and use that GUID for the Offering Registration
echo "Retrieving Catalogs"
CATALOGS=$(eval "${ACURL}" -X GET "${HOST}/catalogs")

if [ -z "${CATALOGS}" ]; then
  echo "  Unable to retrieve catalogs. Check your API_KEY."
  exit 1
fi

# Lets find the Catalog Label and match it to the one we have passed in
for row in $(echo "${CATALOGS}" | jq -r '.resources[] | @base64'); do
  _jq() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

#  echo $(_jq '.label')

  if [[ "$(_jq '.label')" == "${CATALOG_NAME}" ]]; then
    CATALOG_ID=$(_jq '.id')
    echo "  Found catalog: ${CATALOG_NAME}"
  fi
done

# Lets check if we have a Catalog
if [[ -z "${CATALOG_ID}" ]]; then
  echo "Catalog does not exist, please create one with the IBM Console->Manage->Catalogs view "
  exit 1
fi

eval "${ACURL}" -X GET "${HOST}/catalogs/${CATALOG_ID}/offerings" | jq -r '.resources' > "${TMP_DIR}/existing-offerings.json"

# Define the Offering and relationship to the Catalog
IFS=','; for OFFERING in ${OFFERINGS}; do
  echo "Retrieving offering: https://github.com/${GIT_REPO}/releases/download/${VERSION}/${OFFERING}.json"
  curl -sL "https://github.com/${GIT_REPO}/releases/download/${VERSION}/${OFFERING}.json" | \
    jq --arg CATALOG_ID "${CATALOG_ID}" '.catalog_id = $CATALOG_ID | .kinds[0].versions[0].catalog_id = $CATALOG_ID' \
    > "${TMP_DIR}/${OFFERING}.json"

  OFFERING_NAME=$(cat "${TMP_DIR}/${OFFERING}.json" | jq -r '.name')
  OFFERING_VERSION=$(cat "${TMP_DIR}/${OFFERING}.json" | jq -r '.kinds | .[] | .versions | .[] | .version' | head -1)
  echo "  Processing offering: ${OFFERING_NAME}"

  EXISTING_OFFERING=$(cat "${TMP_DIR}/existing-offerings.json" | jq -r --arg NAME "${OFFERING_NAME}" '.[] | select(.name == $NAME)')

  MATCHING_VERSION=$(echo "${EXISTING_OFFERING}" | jq -r --arg VERSION "${OFFERING_VERSION}" '.kinds | .[] | .versions | .[] | select(.version == $VERSION) | .version')

  if [[ -n "${MATCHING_VERSION}" ]]; then
    echo "  Nothing to do. Offering version already registered: ${OFFERING_VERSION}"
  elif [[ -n "${EXISTING_OFFERING}" ]]; then
    OFFERING_ID=$(echo "${EXISTING_OFFERING}" | jq -r '.id')

    NEW_VERSION=$(cat "${TMP_DIR}/${OFFERING}.json" | jq -r '.kinds | .[] | .versions')
    echo "${EXISTING_OFFERING}" | jq --argjson NEW_VERSION "${NEW_VERSION}" '.kinds[0].versions += $NEW_VERSION' > "${TMP_DIR}/${OFFERING}-update.json"

    echo "  Updating existing offering ${OFFERING_ID} in catalog ${CATALOG_ID} with new version: ${OFFERING_VERSION}"
    if eval ${ACURL} -L -X PUT "${HOST}/catalogs/${CATALOG_ID}/offerings/${OFFERING_ID}" --data "@${TMP_DIR}/${OFFERING}-update.json" 1> /dev/null 2> /dev/null; then
      echo "  Offering updated successfully"
    else
      echo "  Error updating offering: ${OFFERING_NAME} ${OFFERING_ID}"
    fi
  else
    echo "  Creating new ${OFFERING} offering in catalog ${CATALOG_ID}"
    if eval ${ACURL} -L -X POST "${HOST}/catalogs/${CATALOG_ID}/offerings" --data "@${TMP_DIR}/${OFFERING}.json" 1> /dev/null 2> /dev/null; then
      echo "  Offering created successfully"
    else
      echo "  Error creating offering: ${OFFERING_NAME}"
    fi
  fi
done

echo "Offering Registration Complete ...!"
rm -rf "${TMP_DIR}"
