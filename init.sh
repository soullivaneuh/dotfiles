#!/usr/bin/env sh

# @see https://github.com/morhetz/gruvbox-contrib/tree/master/xfce4-terminal
mkdir --parent ${HOME}/.local/share/xfce4/terminal/colorschemes
ln --symbolic --force ${HOME}/.gruvbox-contrib/xfce4-terminal/*.theme \
    ${HOME}/.local/share/xfce4/terminal/colorschemes/

echo "Enjoy!"
