#!/usr/bin/env sh
set -e

sudo pacman --sync --refresh

# yay installation
if [[ ! -x "$(command -v yay)" ]]; then
  sudo pacman --sync --noconfirm --needed base-devel git
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg --syncdeps --install --noconfirm
  cd ${HOME}
fi

# Upgrade first to be sure to have repositories up to date
yay -Syu --devel --timeupdate --noconfirm

RUNNING_KERNEL=$(uname -r | egrep -o '[0-9\.-]+[0-9]')
INSTALLED_KERNEL=$(pacman -Q linux | cut -d ' ' -f2)

if [ "$RUNNING_KERNEL" != "$INSTALLED_KERNEL" ]; then
  echo "Kernel changed, reboot needed."
  exit 0
fi

# Package conflicts
yay --remove --noconfirm vim vi || true

yay --sync --needed --noconfirm \
  atom \
  atool \
  asciinema \
  bfs \
  bind-tools \
  browserpass \
  bootiso \
  chromium \
  code \
  colordiff \
  composer \
  cowsay \
  curl \
  dep \
  docker \
  docker-compose \
  expect \
  firefox \
  firefox-developer-edition \
  fzf \
  ghq \
  gnupg \
  go \
  google-chrome \
  google-cloud-sdk \
  gource \
  gtop \
  gvim \
  httpie \
  htop \
  hub \
  imagewriter \
  inetutils \
  jdk-openjdk \
  jq \
  keybase-gui \
  kubernetes-helm-bin \
  make \
  nodejs \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-extra \
  numlockx \
  oomox \
  otf-fira-code \
  otf-font-awesome \
  papirus-icon-theme \
  pass \
  php \
  polybar \
  ripgrep \
  rofi \
  ruby \
  ruby-bundler \
  screenfetch \
  snapd \
  ssh-audit \
  steam \
  subversion \
  termite \
  tmux \
  ttf-fira-code \
  ttf-font-awesome \
  ttf-hack \
  ttf-joypixels \
  vi-vim-symlink \
  wget \
  xfce4-screenshooter \
  xfce4-terminal \
  zsh \
  && echo 'Packages installation finished! \o/'

# Replace default terminal
TERMINAL_PATH=$(which terminal)
sudo rm ${TERMINAL_PATH}
sudo ln -s $(which xfce4-terminal) ${TERMINAL_PATH}

sudo systemctl enable --now snapd
sudo systemctl start snapd && sleep 3
sudo ln --symbolic --force /var/lib/snapd/snap /snap

sudo snap install slack --classic
sudo snap install discord
sudo snap install goland --classic
sudo snap install phpstorm --classic
sudo snap install pycharm-professional --classic
sudo snap install rubymine --classic
sudo snap install webstorm --classic

# Kubernetes specific installation
sudo snap install microk8s --classic
sudo snap alias microk8s.kubectl kubectl
/snap/bin/microk8s.start
/snap/bin/microk8s.kubectl config view --raw > $HOME/.kube/config
helm init --upgrade --wait

sudo usermod --append --groups docker $(whoami)

DOTFILES="github.com/soullivaneuh/dotfiles"
GHQ_ROOT="${HOME}/p" ghq get https://${DOTFILES}
cd "${HOME}/p/${DOTFILES}"
git submodule init
git submodule update
CONFIG_PATH="${HOME}/.config"
if [ -d ${CONFIG_PATH} ]; then
  mv ${CONFIG_PATH} ${CONFIG_PATH}.back
fi
make deploy init
if [ -d ${CONFIG_PATH}.back ]; then
  echo "Backup old .config directory files:"
  for file in ${CONFIG_PATH}.back/*; do
    basefile=$(basename $file)
    echo -n "${basefile} => "
    if [ -e ${CONFIG_PATH}/${basefile} ]; then
      echo "[EXIST]"
      continue
    fi

    cp --recursive $file ${CONFIG_PATH}
    echo "[BACKUP]"
  done
fi
keybase login soullivaneuh || true
if [ -z $(gpg --fingerprint --with-colons | grep -o 04460CD228DF9E0D42F07643992EB6FAFD4E6361) ]; then
 keybase pgp export | gpg --import
 keybase pgp export --secret | gpg --import
 ./gpg-trust.exp FD4E6361
fi
cd -
sudo ln --force --symbolic /run/user/$(id -u)/keybase/kbfs /keybase || true

curl -sLf https://spacevim.org/install.sh | bash

mkdir --parent --mode=700 "${HOME}/.ssh"

DEPLOY="private/soullivaneuh/deploy"
GHQ_ROOT="${HOME}/p" ghq get keybase://${DEPLOY}
bash "${HOME}/p/${DEPLOY}/deploy.sh"

BIN_PATH="${HOME}/bin"
mkdir --parent ${BIN_PATH}

GIT_SRC="github.com/git/git"
GHQ_ROOT="${HOME}/p" ghq get https://${GIT_SRC}
cd "${HOME}/p/${GIT_SRC}/contrib/diff-highlight" && make && cd -
ln --symbolic --force "${HOME}/p/${GIT_SRC}/contrib/diff-highlight/diff-highlight" "${BIN_PATH}/diff-highlight"

sudo chsh -s /bin/zsh $(whoami)

sudo systemctl enable docker.service

# Some system try to call chrom with google-chrome bin
sudo ln --symbolic /usr/bin/google-chrome-stable /usr/bin/google-chrome

# Visual Studio Code base setup
code --install-extension Shan.code-settings-sync

echo "Please reboot."
