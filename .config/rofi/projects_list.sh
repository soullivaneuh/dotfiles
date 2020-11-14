echo -n > ${1}

echo "Fetching GitHub projects..."
hub api --paginate 'user/repos?per_page=100' \
  | jq -r '.[].full_name' \
  | sed -e 's#^#github.com/#' \
  >> ${1}

echo "Fetching GitLab projects..."
LAB_CORE_HOST="https://gitlab.com" LAB_CORE_TOKEN=${GITLAB_TOKEN} lab project list --member --all \
  | sed -e 's#^#gitlab.com/#' \
  >> ${1}

echo "Fetching git.nexylan.net projects..."
LAB_CORE_HOST="https://git.nexylan.net" LAB_CORE_TOKEN=${GITLAB_NEXYLAN_TOKEN} lab project list --member --all \
  | sed -e 's#^#git.nexylan.net/#' \
  >> ${1}

sort ${1}
