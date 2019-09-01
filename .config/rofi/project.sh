set -e

selection=$(ghq list | rofi -dmenu -p "Project" -no-custom)

if [[ ! -z "${selection}" ]]; then
  PROJECT_PATH=${HOME}/p/${selection}
  PROJECT_URL=http://${selection}
  FIREFOX_PROFILE=${HOME}/.firefox-projects/
  code ${HOME}/p/${selection}
  mkdir --parent ${FIREFOX_PROFILE}
  firefox-developer-edition -P project --profile ${FIREFOX_PROFILE} ${PROJECT_URL}
fi

exit 0
