#!/usr/bin/env sh
set -e

# @see https://github.com/swaywm/sway/issues/1628#issuecomment-375058592
export XDG_RUNTIME_DIR=/tmp

sudo xbps-install --yes --automatic \
  void-repo-debug \
  void-repo-multilib \
  void-repo-multilib-nonfree \
  void-repo-nonfree \
  || true

sudo xbps-install -S

sudo xbps-install --yes --automatic \
  archiver \
  asciinema \
  atom \
  bash \
  bfs \
  bind-utils \
  browserpass \
  caddy \
  chromium \
  colordiff \
  curl \
  deepin-screenshot \
  dep \
  docker \
  docker-compose \
  expect \
  feh \
  font-awesome5 \
  font-firacode \
  font-hack-ttf \
  firefox \
  fzf \
  gcc \
  git \
  ghq \
  gnupg \
  go \
  google-cloud-sdk \
  google-fonts-ttf \
  gource \
  httpie \
  htop \
  hub \
  i3 \
  i3lock \
  i3status \
  inetutils \
  kbfs \
  keybase \
  keybase-desktop \
  make \
  nerd-fonts \
  nodejs \
  numlockx \
  openjdk \
  noto-fonts-cjk \
  noto-fonts-emoji \
  noto-fonts-ttf \
  noto-fonts-ttf-extra \
  pass \
  papirus-icon-theme \
  polybar \
  pulseaudio \
  ranger \
  ripgrep \
  rofi \
  ruby \
  ruby-devel \
  ruby-travis \
  rxvt-unicode \
  screenFetch \
  socklog-void \
  ssh-audit \
  steam \
  subversion \
  terminator \
  tmux \
  vim-x11 \
  vpnc \
  vpnc-scripts \
  wget \
  xcb-util-xrm \
  xinit \
  xorg \
  xtools \
  zathura \
  zsh \
  && echo "Packages installation finished! \o/"

sudo usermod --append --groups docker,socklog $(whoami)

for service in \
  dbus \
  docker \
	kube-apiserver \
	kube-controller-manager \
	kube-proxy \
	kube-scheduler \
	kubelet \
  nanoklogd \
  socklog-unix \
  sshd
do
  source=/etc/sv/${service}
  target=/var/service/${service}

  if [ -d ${target} ]; then
    continue
  fi

  sudo rm --recursive --force ${target}

  if ! [ -d ${source} ]; then
    echo "Missing ${source} service directory."
    continue
  fi

  sudo ln --symbolic ${source} ${target}
  echo "Linked service: ${service}"
done

DOTFILES="github.com/soullivaneuh/dotfiles"
GHQ_ROOT="${HOME}/p" ghq get https://${DOTFILES}
cd "${HOME}/p/${DOTFILES}"
git submodule init
git submodule update
rm --recursive --force ${HOME}/.config
make deploy init
keybase login soullivaneuh || true
if [ -z $(gpg --fingerprint --with-colons | grep -o 04460CD228DF9E0D42F07643992EB6FAFD4E6361) ]; then
  keybase pgp export | gpg --import
  keybase pgp export --secret | gpg --import
  ./gpg-trust.exp FD4E6361
fi
cd -

curl -sLf https://spacevim.org/install.sh | bash

DEPLOY="private/soullivaneuh/deploy"
GHQ_ROOT="${HOME}/p" ghq get keybase://${DEPLOY}
bash "${HOME}/p/${DEPLOY}/deploy.sh"

BIN_PATH="${HOME}/bin"
mkdir --parent ${BIN_PATH}

GIT_SRC="github.com/git/git"
GHQ_ROOT="${HOME}/p" ghq get https://${GIT_SRC}
cd "${HOME}/p/${GIT_SRC}/contrib/diff-highlight" && make && cd -
ln --symbolic --force "${HOME}/p/${GIT_SRC}/contrib/diff-highlight/diff-highlight" "${BIN_PATH}/diff-highlight"

BUILDER="github.com/the-maldridge/xbps-mini-builder"
GHQ_ROOT="${HOME}/p" ghq get https://${BUILDER}
cd "${HOME}/p/${BUILDER}"
ln --symbolic --force "${HOME}/p/${DOTFILES}/packages.list"
ln --symbolic --force "${HOME}/p/${DOTFILES}/xbps-src.conf"
./xbps-mini-builder
sudo xbps-install \
  $(cat packages.list) \
  --repository ./void-packages/hostdir/binpkgs/nonfree
cd -

sudo chsh -s /bin/zsh $(whoami)

sudo reboot
