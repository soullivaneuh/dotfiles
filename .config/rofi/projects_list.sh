#!/usr/bin/env bash

list_file=${1}

echo "Fetching GitHub projects..."
hub api --paginate 'user/repos?per_page=100' \
  | jq -r '.[].full_name' \
  | sed -e 's#^#github.com/#' \
  >> "${list_file}"

echo "Fetching GitLab projects..."
LAB_CORE_HOST="https://gitlab.com" LAB_CORE_TOKEN=${GITLAB_TOKEN} lab project list --member --all \
  | sed -e 's#^#gitlab.com/#' \
  >> "${list_file}"

sort "${list_file}"
