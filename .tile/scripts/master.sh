#!/bin/bash
###################################################################################
# Register IBM Cloud Private Catalog Offering within an Existing Catalog
# If the Catalog does not exist it will Create One with the name provided
#
# Author : Matthew Perrins, Sean Sundberg
# email  : mjperrin@us.ibm.com, seansund@us.ibm.com
#
###################################################################################
echo "IBM Cloud Private Catalog Offering Creation!"
echo "This will create a CNCF DevOps Cloud-Native Toolkit Tile in an existing Catalog"

# the API_KEY and Catalog Name are required to run this script
API_KEY="$1"
CATALOG_NAME="$2"
OFFERINGS="$3"
VERSION="$4"

# input validation
if [ -z "${API_KEY}" ]; then
    echo "Please provide your API_KEY as first parameter"
    exit
fi

# input validation
if [ -z "${CATALOG_NAME}" ]; then
    echo "Please provide your CATALOG_NAME as second parameter"
    exit
fi

if [ -z "${GIT_REPO}" ]; then
  GIT_REPO="#GIT_REPO"
fi

if [ -z "${OFFERINGS}" ]; then
  OFFERINGS="#OFFERINGS"
fi

# input validation, Version is provided when the packaged release of this repository is created
if [ -z "${VERSION}" ]; then
  VERSION=latest
fi

if [ "$VERSION" == "latest" ]; then
  VERSION=$(curl -sL "https://api.github.com/repos/${GIT_REPO}/releases/latest" | grep "tag_name" | sed -E "s/.*\"tag_name\": \"(.*)\".*/\1/")
  echo "  The latest version is $VERSION"
fi

# Get a Bearer Token from IBM Cloud IAM
IAM_AUTH=$(curl -s -k -X POST \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --header "Accept: application/json" \
  --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
  --data-urlencode "apikey=${API_KEY}" \
  "https://iam.cloud.ibm.com/identity/token")

# Extract the Bearer Token from IAM response
TOKEN=$(echo $IAM_AUTH |  jq '.access_token' | tr -d '"')
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

# Lets find the Catalog Label and match it to the one we have passed in
for row in $(echo "${CATALOGS}" | jq -r '.resources[] | @base64'); do
  _jq() {
   echo ${row} | base64 --decode | jq -r ${1}
  }

#  echo $(_jq '.label')

  if [[ "$(_jq '.label')" == ${CATALOG_NAME} ]]; then
    CATALOG_ID=$(_jq '.id')
    echo "  Found catalog: ${CATALOG_NAME}"
  fi
done

# Lets check if we have a Catalog
if [ -z "${CATALOG_ID}" ]; then
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