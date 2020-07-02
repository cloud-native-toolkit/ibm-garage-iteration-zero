#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
REPO_DIR=$(cd ${SCRIPT_DIR}/../..; pwd -P)

if [[ -n "$GITHUB_USERNAME" ]] && [[ -n "$GITHUB_TOKEN" ]]; then
  GITHUB_AUTH="-u ${GITHUB_USERNAME}:${GITHUB_TOKEN}"
fi

set -e

ls "${REPO_DIR}"/terraform/stages/*.tf | while read stageFile; do
  echo "Updating stage: $stageFile"
  SOURCES=$(grep -E 'source *=' "${stageFile}" | sed -E 's/.*source *= *"(.*)"/\1/g')

  echo "${SOURCES}" | while read source; do
    if [[ -z "$source" ]]; then
      continue
    fi

    git_slug=$(echo "$source" | sed -E 's~github.com/(.*).git.*~\1~g')

    git_release_url="https://api.github.com/repos/${git_slug}/releases/latest"

    latest_release=$(curl ${GITHUB_AUTH} -s "${git_release_url}" | grep tag_name | sed -E "s/.*\"tag_name\": \"(.*)\".*/\1/")

    if [[ -n "${latest_release}" ]]; then
      latest_source=$(echo "${source}" | sed -E "s/(.*)=.*/\1=${latest_release}/g")

      echo "  ++ Latest source for ${git_slug} is ${latest_source}"
      sed -i "" "s~${source}~${latest_source}~g" "${stageFile}"
    else
      echo "  ** Release not found for ${git_release_url}"
    fi
  done
done
