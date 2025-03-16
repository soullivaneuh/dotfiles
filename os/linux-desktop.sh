#!/usr/bin/env sh
set -e
. /etc/os-release

sudo apt update
sudo apt dist-upgrade --yes
sudo apt install --yes \
  zsh


echo "Please reboot."
