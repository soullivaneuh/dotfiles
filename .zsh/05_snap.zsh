SNAP_LOCK=${TMP_PATH}/snap.lock
! [[ -f "${SNAP_LOCK}" ]] && touch ${SNAP_LOCK} || return 0
if ! [[ -x "$(command -v snap)" ]];then
  echo "Missing snap command"
  return 1
fi

snap_install()
{
  local PACKAGE=${1}
  shift
  local OPTIONS=${@}

  snap list ${PACKAGE} >> /dev/null 2>&1 || sudo snap install ${PACKAGE} "$@"
}

snap_alias()
{
  local APP=${1}
  local ALIAS=${2}

  which ${ALIAS} >> /dev/null 2>&1 || sudo snap alias ${APP} ${ALIAS}
}

# Languages
snap_install ruby --classic
snap_install go --classic
snap_install node --classic

# Docker & Kubernetes
snap_install microk8s --classic --channel=1.13/edge/secure-containerd
snap_alias microk8s.kubectl kubectl
snap_install helm --classic

# IDE
snap_install atom --classic
snap_install goland --classic
snap_install phpstorm --classic
snap_install pycharm-professional --classic
snap_install rubymine --classic
snap_install webstorm --classic

# Tools
snap_install google-cloud-sdk --classic
snap_install hub --classic
snap_install ripgrep --classic
snap_install travis

# Communication
snap_install discord
snap_install slack --classic

unfunction snap_install snap_alias
