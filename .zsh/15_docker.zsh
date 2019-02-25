export DOCKER_HOST="unix:///var/snap/microk8s/current/docker.sock"

DOCKER_LOCK=${TMP_PATH}/docker.lock
! [[ -f "${DOCKER_LOCK}" ]] && touch ${DOCKER_LOCK} || return 0
[[ -x "$(command -v docker)" ]] || (echo "Missing microk8s setup" && return 1)

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

# @see https://github.com/ubuntu/microk8s/issues/173#issuecomment-466792021
# @see https://github.com/ubuntu/microk8s#configuring-microk8s-services
DOCKERD_SNAP_ARGS=/var/snap/microk8s/current/args/dockerd
DOCKERD_ARGS="--config-file=${HOME}/.docker/daemon.json"
grep --quiet --line-regexp --fixed-strings -- ${DOCKERD_ARGS} ${DOCKERD_SNAP_ARGS} \
  || (echo ${DOCKERD_ARGS} | sudo tee --append ${DOCKERD_SNAP_ARGS} && sudo systemctl restart snap.microk8s.daemon-docker.service)
