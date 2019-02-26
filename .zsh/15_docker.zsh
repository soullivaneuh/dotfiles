DOCKER_LOCK=${TMP_PATH}/docker.lock
! [[ -f "${DOCKER_LOCK}" ]] && touch ${DOCKER_LOCK} || return 0
if ! [[ -x "$(command -v docker)" ]]; then
  echo "Missing docker setup"
  curl -fsSL https://get.docker.com | sh
fi
if ! [[ -x "$(command -v microk8s.status)" ]]; then
  echo "Missing microk8s setup"
  return 1
fi
[[ -x "$(command -v microk8s.status)" ]] || (echo "Missing microk8s setup" && return 1)

if ! [[ -L /etc/docker/daemon.json ]]; then
  sudo rm --force /etc/docker/daemon.json
  sudo mkdir --parent /etc/docker
  sudo ln --symbolic ${HOME}/.docker/daemon.json /etc/docker/daemon.json
  echo "Docker settings replaced. Please restart docker."
  sudo groupadd docker
  sudo usermod -aG docker ${USER}
  echo "Docker group setup. Session restart is necessary."
fi

microk8s.status || (microk8s.start && microk8s.status --wait-ready)
k8s_addon()
{
  local K8S_STATUS_PATH=/tmp/.k8s-status

  microk8s.status > ${K8S_STATUS_PATH}

  for addon in "$@"
  do
      grep --quiet --fixed-strings "${addon}: enabled" ${K8S_STATUS_PATH} \
      || microk8s.enable ${addon}
  done
}
k8s_addon dns dashboard registry
unfunction k8s_addon

helm init --upgrade
helm repo update
