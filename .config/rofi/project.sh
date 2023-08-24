#!/usr/bin/env bash
set -e

plist=/tmp/sullivan/plist
plist_ghq=/tmp/sullivan/plist-ghq
plist_dist=/tmp/sullivan/plist-dist

ghq list > ${plist_ghq}
test -f ${plist_dist} || alacritty --title "Projects fetching" --command bash ${HOME}/.config/rofi/projects_list.sh ${plist_dist}

cat ${plist_ghq} ${plist_dist} | awk '!x[$0]++' > ${plist}

selection=$(rofi -dmenu -p "Project" -no-custom -i -input ${plist})

if [[ -z "${selection}" ]]; then
  exit 0
fi
PROJECT_PATH=${HOME}/p/${selection}

if [[ ! -d "${PROJECT_PATH}" ]]; then
  alacritty --title "Cloning of ${PROJECT_PATH}" --command ghq get -p ${selection}
fi

# Visual code launch
code "${PROJECT_PATH}"

exit 0
