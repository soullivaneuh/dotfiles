set -e

selection=$(ghq list | rofi -dmenu -p "Project" -no-custom)

FIREFOX_PID=~/.firefox-dev-pid
touch ${FIREFOX_PID}
kill $(cat ${FIREFOX_PID}) || true

if [[ ! -z "${selection}" ]]; then
  # Visual code launch
  PROJECT_PATH=${HOME}/p/${selection}
  code --reuse-window ${PROJECT_PATH}

  # Firefox profile setup
  FIREFOX_PROFILE=${HOME}/.firefox-projects/${selection}
  DEFAULT_PROFILE=${HOME}/.mozilla/firefox/$(grep 'Default=' ${HOME}/.mozilla/firefox/profiles.ini | head -n 1 | cut -d = -f2)
  mkdir --parent ${FIREFOX_PROFILE}
  ln --force --symbolic ${DEFAULT_PROFILE}/signedInUser.json ${FIREFOX_PROFILE}
  ln --force --symbolic ${DEFAULT_PROFILE}/logins.json ${FIREFOX_PROFILE}
  ln --force --symbolic ${DEFAULT_PROFILE}/key4.db ${FIREFOX_PROFILE}
  cp ~/.config/rofi/firefox_pref.js ${FIREFOX_PROFILE}/user.js

  # Frifox session launch
  PROJECT_URL=http://${selection}
  firefox-developer-edition \
    --profile ${FIREFOX_PROFILE} \
    ${PROJECT_URL} &
  echo $! > ${FIREFOX_PID}
fi

exit 0
