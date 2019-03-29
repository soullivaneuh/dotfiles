DOCKER_LOCK=${TMP_PATH}/docker.lock
! [[ -f "${DOCKER_LOCK}" ]] && touch ${DOCKER_LOCK} || return 0
if ! [[ -x "$(command -v docker)" ]]; then
  echo "Missing docker setup"
  curl -fsSL https://get.docker.com | sh
fi

if ! [[ -L /etc/docker/daemon.json ]]; then
  sudo rm --force /etc/docker/daemon.json
  sudo mkdir --parent /etc/docker
  sudo ln --symbolic ${HOME}/.docker/daemon.json /etc/docker/daemon.json
  echo "Docker settings replaced. Please restart docker."
fi
