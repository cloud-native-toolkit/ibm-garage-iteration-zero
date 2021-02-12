#!/usr/bin/env sh

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

STAGES_DIRECTORY="stages-assign-users"

set -e

echo 'Building new version of Tile from Iteration Zero Terraform Modules'

OUTPUT_DIR="$1"
OFFERING_NAME="$2"
VERSION="$3"
REPO_SLUG="$4"

if [ -z "${OUTPUT_DIR}" ]; then
  echo "The output dir is required as the first argument"
  exit 1
fi

mkdir -p "${OUTPUT_DIR}"
OUTPUT_DIR=$(cd "$OUTPUT_DIR"; pwd -P)

if [ -z "${OFFERING_NAME}" ]; then
  echo "The offering name is required as the second argument"
  exit 1
fi

if [ -z "${VERSION}" ]; then
  VERSION="#VERSION"
fi

if [ -z "${REPO_SLUG}" ]; then
  REPO_SLUG="ibm-garage-cloud/ibm-garage-iteration-zero"
fi

REPO_URL="https://github.com/${REPO_SLUG}"

WORKSPACE_BASE="./workspace"
WORKSPACE_DIR="${WORKSPACE_BASE}/${OFFERING_NAME}"
mkdir -p "${WORKSPACE_DIR}"

SRC_DIR="./terraform"

cp "${SRC_DIR}/${STAGES_DIRECTORY}/variables.tf" "${WORKSPACE_DIR}"
cp "${SRC_DIR}/${STAGES_DIRECTORY}"/stage*.tf "${WORKSPACE_DIR}"
cp "${SRC_DIR}"/scripts-workspace/* "${WORKSPACE_DIR}"
cp README.md "${WORKSPACE_DIR}/SCRIPTS.md"
cp "${SCRIPT_DIR}/README.md" "${WORKSPACE_DIR}"

echo "  - Creating offering - ${OUTPUT_DIR}/${OFFERING_NAME}.tar.gz"
cd "${WORKSPACE_BASE}" && tar czf "${OUTPUT_DIR}/${OFFERING_NAME}.tar.gz" "${OFFERING_NAME}"
cd - 1> /dev/null
rm -rf "${WORKSPACE_BASE}"

echo "  - Creating offering json - ${OUTPUT_DIR}/offering-${OFFERING_NAME}.json"
jq \
  --arg OFFERING "${OFFERING_NAME}" \
  --arg VERSION "${VERSION}" \
  --arg REPO_URL "${REPO_URL}" \
  --arg TGZ_URL "${REPO_URL}/releases/download/${VERSION}/${OFFERING_NAME}.tar.gz" \
  --rawfile LONG_DESCRIPTION "${SCRIPT_DIR}/README.md" \
  '.name = $OFFERING | .kinds[0].versions[0] += {version: $VERSION, repo_url: $REPO_URL, tgz_url: $TGZ_URL, long_description: $LONG_DESCRIPTION}' \
  "${SCRIPT_DIR}/offering.json" \
  > "${OUTPUT_DIR}/offering-${OFFERING_NAME}.json"

echo 'Build complete .......'
