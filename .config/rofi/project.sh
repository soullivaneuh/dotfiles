set -e

plist=/tmp/sullivan/plist
plist_ghq=/tmp/sullivan/plist-ghq
plist_github=/tmp/sullivan/plist-github

ghq list > ${plist_ghq}
test -f ${plist_github} || hub api --paginate 'user/repos?per_page=100' | jq -r '.[].full_name' | sed -e 's#^#github.com/#' > ${plist_github}

cat ${plist_ghq} ${plist_github} | awk '!x[$0]++' > ${plist}

selection=$(rofi -dmenu -p "Project" -no-custom -i -input ${plist})

if [[ -z "${selection}" ]]; then
  exit 0
fi
PROJECT_PATH=${HOME}/p/${selection}

i3-msg workspace ${selection}
if [[ ! -d "${PROJECT_PATH}" ]]; then
  termite --exec="ghq get ${selection}"
fi

# Visual code launch
code ${PROJECT_PATH}

# Firefox profile setup
FIREFOX_PROFILE=${HOME}/.firefox-projects/${selection}
DEFAULT_PROFILE=${HOME}/.mozilla/firefox/$(grep 'Default=' ${HOME}/.mozilla/firefox/profiles.ini | head -n 1 | cut -d = -f2)
mkdir --parent ${FIREFOX_PROFILE}
ln --force --symbolic ${DEFAULT_PROFILE}/signedInUser.json ${FIREFOX_PROFILE}
ln --force --symbolic ${DEFAULT_PROFILE}/logins.json ${FIREFOX_PROFILE}
ln --force --symbolic ${DEFAULT_PROFILE}/key4.db ${FIREFOX_PROFILE}
cp ${DEFAULT_PROFILE}/cookies.sqlite ${FIREFOX_PROFILE}
cp ${DEFAULT_PROFILE}/cookies.sqlite-wal ${FIREFOX_PROFILE}
cp ~/.config/rofi/firefox_pref.js ${FIREFOX_PROFILE}/user.js

# Frifox session launch
PROJECT_URL=http://${selection}
FIREFOX_PID=$(ps ax | grep ${FIREFOX_PROFILE} | grep -v grep | awk {'print $1'})
if [[ -z "${FIREFOX_PID}" ]]; then
  firefox-developer-edition \
    --profile ${FIREFOX_PROFILE} \
    ${PROJECT_URL} &
  echo $! > ${FIREFOX_PID}
fi

exit 0
