#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
REPO_DIR=$(cd ${SCRIPT_DIR}/../..; pwd -P)

if [[ -n "$GITHUB_USERNAME" ]] && [[ -n "$GITHUB_TOKEN" ]]; then
  GITHUB_AUTH="-u ${GITHUB_USERNAME}:${GITHUB_TOKEN}"
fi

CHANGED_REPO="$1"

if [[ -n "${CHANGED_REPO}" ]]; then
  echo "** Updating modules based on filter: ${CHANGED_REPO}"
else
  echo "** Updating all modules"
fi

set -e

ls "${REPO_DIR}/terraform" | while read -r dir; do
  if [[ ! -d "${REPO_DIR}/terraform/${dir}" ]] || [[ ! "${dir}" =~ stages* ]]; then
    continue
  fi

  STAGES_DIR="${REPO_DIR}/terraform/${dir}"

  echo "Reading terraform stages: ${STAGES_DIR}"
  ls "${STAGES_DIR}" | while read -r file; do
    stageFile="${STAGES_DIR}/${file}"

    if [[ ! -f "${stageFile}" ]] || [[ ! "${stageFile}" =~ .*tf$ ]]; then
      continue
    fi

    SOURCES=$(grep -E 'source *=' "${stageFile}" | sed -E 's/.*source *= *"(.*)"/\1/g')

    echo "${SOURCES}" | while read -r source; do
      if [[ -z "$source" ]]; then
        continue
      fi

      git_slug=$(echo "$source" | sed -E 's~github.com/(.*)\?.*~\1~g' | sed "s/.git//g")

      if [[ -z "${CHANGED_REPO}" ]] || [[ "${git_slug}" == "${CHANGED_REPO}" ]]; then
        echo " - Updating stage: $stageFile"
        echo " - Checking for latest version of ${git_slug}"
      else
        continue
      fi

      git_release_url="https://api.github.com/repos/${git_slug}/releases/latest"

      latest_release=$(curl ${GITHUB_AUTH} -s "${git_release_url}" | grep tag_name | sed -E "s/.*\"tag_name\": \"(.*)\".*/\1/")

      if [[ -n "${latest_release}" ]]; then
        latest_source=$(echo "${source}" | sed -E "s/(.*)=.*/\1=${latest_release}/g")

        echo "  ++ Latest source for ${git_slug} is ${latest_source}"
        sed "s~${source}~${latest_source}~g" "${stageFile}" > "${stageFile}.tmp" && \
          rm "${stageFile}" && \
          mv "${stageFile}.tmp" "${stageFile}"
      else
        echo "  ** Release not found for ${git_release_url}"
      fi
    done
  done
done
