#!/usr/bin/env bash
set -e

plist=/tmp/sullivan/plist
plist_ghq=/tmp/sullivan/plist-ghq
plist_dist=/tmp/sullivan/plist-dist

ghq list > ${plist_ghq}
test -f ${plist_dist} || termite --exec="bash ${HOME}/.config/rofi/projects_list.sh ${plist_dist}"

cat ${plist_ghq} ${plist_dist} | awk '!x[$0]++' > ${plist}

selection=$(rofi -dmenu -p "Project" -no-custom -i -input ${plist})

if [[ -z "${selection}" ]]; then
  exit 0
fi
PROJECT_PATH=${HOME}/p/${selection}

if [[ ! -d "${PROJECT_PATH}" ]]; then
  termite --exec="ghq get -p ${selection}"
fi

cd "${PROJECT_PATH}"

if [[ $selection == github.com/* ]] || [[ $selection == git.nexylan.net/* ]]; then
  git config remote.origin.fetch '+refs/pull/*:refs/remotes/origin/pr/*'
fi
if [[ $selection == gitlab.com/* ]] || [[ $selection == git.nexylan.net/* ]]; then
  git config remote.origin.fetch '+refs/merge-requests/*:refs/remotes/origin/mr/*'
fi

# Visual code launch
code .

exit 0
