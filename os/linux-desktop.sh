#!/usr/bin/env sh
set -e
. /etc/os-release

sudo apt update
sudo apt dist-upgrade --yes
sudo apt install --yes \
  fonts-firacode \
  fonts-font-awesome \
  fonts-hack \
  fonts-noto \
  fonts-noto-cjk \
  fonts-noto-extra \
  dconf-editor \
  gnome-tweaks \
  numlockx \
  papirus-icon-theme \
  polybar \
  rofi \
  xfce4-screenshooter \
  xfce4-terminal

# Alacritty
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt update
sudo apt install --yes alacritty

# Google Chrome
sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
wget -O- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/linux_signing_key.pub
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13
sudo apt update
sudo apt install --yes google-chrome-stable

# Snap only packages.
# And yes, we have to do this shitty commands chaining because
# snap does not understand having an already installed package
# is not that a deal.
snap list | awk '{print $1}' | grep -q "^discord$" || snap install discord
snap list | awk '{print $1}' | grep -q "^code$" || snap install --classic code

# Regolith desktop
# https://regolith-desktop.com/#get-regolith-22
wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_1-ubuntu-${VERSION_CODENAME}-amd64 ${VERSION_CODENAME} main" | \
sudo tee /etc/apt/sources.list.d/regolith.list
sudo apt update
sudo apt install --yes \
  regolith-desktop \
  regolith-session-flashback \
  regolith-look-gruvbox \
  i3xrocks-keyboard-layout \
  i3xrocks-time

# Docker
# @see https://docs.docker.com/engine/install/ubuntu/
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove $pkg; done
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable"
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt update
sudo apt install --yes apt-transport-https ca-certificates curl software-properties-common
sudo apt install docker-ce

sudo usermod --append --groups docker "$(whoami)"

# Podman
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/Debian_Testing/Release.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg > /dev/null
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg]\
    https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/Debian_Testing/ /" \
  | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:unstable.list > /dev/null
curl -fsSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/Debian_Unstable/Release.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg > /dev/null
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg]\
    https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/Debian_Unstable/ /" \
  | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:unstable.list > /dev/null
sudo apt update
sudo apt -y upgrade
sudo apt -y install podman
# Enable rootls podman socket
systemctl --user enable --now podman.socket

sudo systemctl enable docker.service
# NTP service for datetime sync.
sudo systemctl enable systemd-timesyncd.service

# Replace default tderminal
# @see https://stackoverflow.com/a/16808639
sudo update-alternatives --set x-terminal-emulator $(which xfce4-terminal).wrapper

echo "Please reboot."
