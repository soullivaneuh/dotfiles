GEM_LOCK=${TMP_PATH}/gem.lock
! [[ -f "${GEM_LOCK}" ]] && touch ${GEM_LOCK} || return 0
if ! [[ -x "$(command -v gem)" ]];then
  echo "Missing gem command"
  return 1
fi

gem install cani
