#!/usr/bin/env sh

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

set -e

echo 'Building new version of Tile from Iteration Zero Terraform Modules'

OUTPUT_DIR="$1"

if [ -z "${OUTPUT_DIR}" ]; then
  echo "The output dir is required as the first argument"
  exit 1
fi

mkdir -p "${OUTPUT_DIR}"
OUTPUT_DIR=$(cd "$OUTPUT_DIR"; pwd -P)

OFFERING_NAME="$2"
if [ -z "${OFFERING_NAME}" ]; then
  echo "The offering name is required as the second argument"
  exit 1
fi

VERSION="$3"
if [ -z "${VERSION}" ]; then
  VERSION="#VERSION"
fi

WORKSPACE_DIR="./workspace"
mkdir -p "${WORKSPACE_DIR}"

SRC_DIR="./terraform"

ENVIRONMENT_TFVARS="${SRC_DIR}/settings/environment.tfvars"
TFVARS="${WORKSPACE_DIR}/terraform.tfvars"
cat "${ENVIRONMENT_TFVARS}" > "${TFVARS}"

# Read terraform.tfvars to see if cluster_exists, postgres_server_exists, and cluster_type are set
# If not, get them from the user and write them to a file

CLUSTER_MANAGEMENT="ibmcloud"
CLUSTER_TYPE="openshift"
STAGES_DIRECTORY="stages"

cp "${SRC_DIR}/${STAGES_DIRECTORY}/variables.tf" "${WORKSPACE_DIR}"
cp "${SRC_DIR}/${STAGES_DIRECTORY}"/stage*.tf "${WORKSPACE_DIR}"
cp "${SRC_DIR}"/scripts-workspace/* "${WORKSPACE_DIR}"
cp README.MD "${WORKSPACE_DIR}/SCRIPTS.md"
cp "${SCRIPT_DIR}/../docs/README.md" "${WORKSPACE_DIR}"

# Move some stages to an unused folder
rm "${WORKSPACE_DIR}/stage3-logdna.tf"
rm "${WORKSPACE_DIR}/stage3-sysdig.tf"

echo "  - Creating offering - ${OUTPUT_DIR}/${OFFERING_NAME}.tar.gz"
cd "${WORKSPACE_DIR}" && tar czf "${OUTPUT_DIR}/${OFFERING_NAME}.tar.gz" .
cd - 1> /dev/null
rm -rf "${WORKSPACE_DIR}"

echo "  - Creating offering json - ${OUTPUT_DIR}/offering-${OFFERING_NAME}.json"
sed "s/#OFFERING/${OFFERING_NAME}/g" "${SCRIPT_DIR}/master.json" | sed "s/#VERSION/${VERSION}/g" > "${OUTPUT_DIR}/offering-${OFFERING_NAME}.json"

echo 'Build complete .......'
