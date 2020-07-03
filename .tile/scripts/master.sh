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
OFFERING="$3"
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
  GIT_REPO="ibm-garage-cloud/ibm-garage-iteration-zero"
fi

if [ -z "${OFFERING}" ]; then
  OFFERING="offering-cloudnative-toolkit.json"
fi

# input validation, Version is provided when the packaged release of this repository is created
if [ -z "${VERSION}" ]; then
  VERSION=latest
fi

if [ "$VERSION" == "latest" ]; then
  VERSION=$(curl -s "https://api.github.com/repos/${GIT_REPO}/releases/latest" | grep "tag_name" | sed -E "s/.*\"tag_name\": \"(.*)\".*/\1/")
  echo "The latest version is $VERSION"
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
ACURL="curl -s -g -H 'Authorization: ${BEARER_TOKEN}'"
HOST="https://cm.globalcatalog.cloud.ibm.com/api/v1-beta"

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
    echo "Found ${CATALOG_NAME} creating offering inside this one"
  fi
done

# Lets check if we have a Catalog
if [ -z "${CATALOG_ID}" ]; then
  echo "Catalog does not exist, please create one with the IBM Console->Manage->Catalogs view "
  exit
fi

# Define the Offering and relationship to the Catalog
curl -sL "https://github.com/${GIT_REPO}/releases/download/${VERSION}/${OFFERING}" | sed "s/#CATALOG_ID/${CATALOG_ID}/g" | sed "s/#VERSION/${VERSION}/g" > offering.json

echo "Creating Offering in Catalog ${CATALOG_ID}"
CATALOGS=$(eval ${ACURL} -location -request POST "${HOST}/catalogs/${CATALOG_ID}/offerings" -H 'Content-Type: application/json' --data "@offering.json")

echo "Offering Registration Complete ...!"