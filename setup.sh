#!/usr/bin/env sh
set -e

sudo apt-get update
sudo apt-get dist-upgrade --yes
sudo apt-get install --yes \
  asciinema \
  atool \
  bfs \
  colordiff \
  composer \
  cowsay \
  curl \
  dconf-editor \
  expect \
  fonts-firacode \
  fonts-font-awesome \
  fonts-hack \
  fonts-noto \
  fonts-noto-cjk \
  fonts-noto-extra \
  fzf \
  git-extras \
  gnome-tweaks \
  gnupg2 \
  gource \
  gpg \
  htop \
  httpie \
  hub \
  jq \
  make \
  net-tools \
  nodejs \
  npm \
  numlockx \
  papirus-icon-theme \
  php \
  polybar \
  ripgrep \
  rofi \
  ruby \
  ruby-bundler \
  screenfetch \
  ssh-audit \
  steam \
  subversion \
  tmux \
  vim \
  wget \
  xfce4-screenshooter \
  zsh

# Alacritty
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt-get update
sudo apt-get install alacritty

# Google Chrome
sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
wget -O- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/linux_signing_key.pub
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13
sudo apt-get update
sudo apt-get install google-chrome-stable

# Snap only packages.
# And yes, we have to do this shitty commands chaining because
# snap does not understand having an already installed package
# is not that a deal.
snap list | awk '{print $1}' | grep -q "^discord$" || snap install discord
snap list | awk '{print $1}' | grep -q "^slack$" || snap install slack
snap list | awk '{print $1}' | grep -q "^code$" || snap install --classic code

# Regolith desktop
# https://regolith-desktop.com/#get-regolith-22
wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-ubuntu-jammy-amd64 jammy main" | \
sudo tee /etc/apt/sources.list.d/regolith.list
sudo apt-get update
sudo apt-get install regolith-desktop regolith-look-gruvbox

# GoLang
wget -O go.tar.gz https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz
rm -f go.tar.gz
export PATH=$PATH:/usr/local/go/bin

# GHQ
wget -O ghq.zip https://github.com/x-motemen/ghq/releases/download/v1.4.2/ghq_linux_amd64.zip
unzip -o ghq.zip
sudo cp ./ghq_linux_amd64/ghq /usr/local/bin
rm -rf ghq_linux_amd64 ghq.zip

# LAB
curl -s https://raw.githubusercontent.com/zaquestion/lab/master/install.sh | sudo bash

# Keybase
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt-get install ./keybase_amd64.deb
rm -f keybase_amd64.deb

# Docker
# @see https://docs.docker.com/engine/install/ubuntu/
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable"
# @see
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
sudo apt install docker-ce

sudo usermod --append --groups docker "$(whoami)"

git submodule init
git submodule update
git remote set-url origin git@github.com:soullivaneuh/dotfiles.git
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

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

# RVM
curl -sSL https://get.rvm.io | bash

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
# NTP service for datetime sync.
sudo systemctl enable systemd-timesyncd.service

# Replace default tderminal
# @see https://stackoverflow.com/a/16808639
sudo update-alternatives --set x-terminal-emulator $(which xfce4-terminal).wrapper

echo "Please reboot."
