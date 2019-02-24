SNAP_LOCK=${TMP_PATH}/snap.lock
! [[ -f "${SNAP_LOCK}" ]] && touch ${SNAP_LOCK} || return 0
[[ -x "$(command -v snap)" ]] || (echo "Missing snap command" && return 1)

snap_install()
{
  local PACKAGE=${1}
  shift
  local OPTIONS=${@}

  snap list ${PACKAGE} >> /dev/null 2>&1 || sudo snap install ${PACKAGE} ${OPTIONS}
}

snap_alias()
{
  local APP=${1}
  local ALIAS=${2}

  which ${ALIAS} >> /dev/null 2>&1 || sudo snap alias ${APP} ${ALIAS}
}

# Docker & Kubernetes
snap_install microk8s --classic
snap_alias microk8s.kubectl kubectl
snap_alias microk8s.docker docker
snap_install helm --classic

# IDE
snap_install atom --classic
snap_install goland --classic
snap_install phpstorm --classic
snap_install pycharm-professional --classic
snap_install rubymine --classic
snap_install webstorm --classic

# Tools
sudo snap install google-cloud-sdk --classic
sudo snap install hub --classic
sudo snap install travis

# Communication
snap_install discord
snap_install slack --classic

unfunction snap_install snap_alias
