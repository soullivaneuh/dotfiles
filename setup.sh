#!/usr/bin/env sh
set -e
. /etc/os-release

sudo apt update
sudo apt dist-upgrade --yes
# Programation languages
sudo apt install --yes \
  php-cli \
  composer \
  golang-go \
  ruby \
  ruby-bundler
# Utilities
sudo apt install --yes \
  asciinema \
  atool \
  bfs \
  btop \
  colordiff \
  curl \
  expect \
  fzf \
  git-extras \
  gnupg2 \
  gpg \
  htop \
  httpie \
  hub \
  jq \
  make \
  net-tools \
  ripgrep \
  screenfetch \
  ssh-audit \
  subversion \
  tmux \
  vim \
  wget \
  zsh

# GHQ
wget -O ghq.zip https://github.com/x-motemen/ghq/releases/download/v1.4.2/ghq_linux_amd64.zip
unzip -o ghq.zip
sudo cp ./ghq_linux_amd64/ghq /usr/local/bin
rm -rf ghq_linux_amd64 ghq.zip

# LAB
# @see https://raw.githubusercontent.com/zaquestion/lab/master/install.sh
# Simplified with locked version
# @see https://github.com/zaquestion/lab/issues/843
latest="0.24.0"
tempFolder="/tmp/lab_v${latest}"
mkdir -p "${tempFolder}" 2> /dev/null
curl -sL "https://github.com/zaquestion/lab/releases/download/v${latest}/lab_${latest}_linux_amd64.tar.gz" | tar -C "${tempFolder}" -xzf -
sudo install -m755 "${tempFolder}/lab" /usr/bin/lab
rm -rf "${tempFolder}"

# ???
# Keybase
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install --yes ./keybase_amd64.deb
rm -f keybase_amd64.deb

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

echo "Please reboot."
