#!/usr/bin/env bash

JENKINS_HOST="$1"
USER_NAME="$2"
API_TOKEN="$3"
GIT_REPO="$4"
GIT_CREDENTIALS="$5"

if [[ -z "${JENKINS_HOST}" ]] || [[ -z "${USER_NAME}" ]] || [[ -z "${API_TOKEN}" ]] || [[ -z "${GIT_REPO}" ]] || [[ -z "${GIT_CREDENTIALS}" ]]; then
    echo -e "Pipeline registration script is missing required fields"
    echo -e "Usage: $0 {JENKINS_HOST} {USER_NAME} {API_TOKEN} {GIT_REPO} [{GIT_BRANCH}] [{CONFIG_FILE}]"
    echo -e "  where:"
    echo -e "    JENKINS_HOST - the host name of the Jenkins server"
    echo -e "    USER_NAME - the Jenkins user name"
    echo -e "    API_TOKEN - the Jenkins api token"
    echo -e "    GIT_REPO - the url of the git repo"
    echo -e "    GIT_CREDENTIALS - the name of the secret holding the git credentials"
    echo -e "    GIT_BRANCH - (optional) the branch that should be registered for the build. Defaults to 'master'"
    echo -e "    CONFIG_FILE - (optional) the file containing the pipeline config. Defaults to 'config-template.xml'"
    echo -e ""
    exit 1
fi

GIT_BRANCH="master"
CONFIG_FILE="config-template.xml"

if [[ -z "$6" ]]; then
    GIT_BRANCH="$6"
fi
if [[ -z "$7" ]]; then
    CONFIG_FILE="$7"
fi

JOB_NAME=$(echo "${GIT_REPO}" | sed -e "s~.*/\(.*\)~\1~" | sed "s/.git//")
if [[ "${GIT_BRANCH}" != "master" ]]; then
    JOB_NAME="${JOB_NAME}-${GIT_BRANCH}"
fi

CRUMB=$(curl -s "${JENKINS_HOST}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)" -u "${USER_NAME}:${API_TOKEN}")
cat ${CONFIG_FILE} | \
    sed "s~{{GIT_REPO}}~${GIT_REPO}~g" | \
    sed "s~{{GIT_CREDENTIALS}}~${GIT_CREDENTIALS}~g" | \
    sed "s~{{GIT_BRANCH}}~${GIT_BRANCH}~g" | \
    curl -s -X POST "${JENKINS_HOST}/createItem?name=${JOB_NAME}" -u "${USER_NAME}:${API_TOKEN}" -d @- -H "${CRUMB}" -H "Content-Type:text/xml"
