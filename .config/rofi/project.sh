set -e

selection=$(ghq list | rofi -dmenu -p "Project" -no-custom)

if [[ ! -z "${selection}" ]]; then
  i3-msg workspace ${selection}
  # Avoid buggy firefox resolution issue (bad website render).
  sleep 0.2

  # Visual code launch
  PROJECT_PATH=${HOME}/p/${selection}
  code ${PROJECT_PATH}

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
  FIREFOX_PID=$(ps ax | grep ${FIREFOX_PROFILE} | grep -v grep | awk {'print $1'})
  if [[ -z "${FIREFOX_PID}" ]]; then
    firefox-developer-edition \
      --profile ${FIREFOX_PROFILE} \
      ${PROJECT_URL} &
    echo $! > ${FIREFOX_PID}
  fi
fi

exit 0
