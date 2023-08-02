#!/usr/bin/env sh

# @see https://github.com/morhetz/gruvbox-contrib/tree/master/xfce4-terminal
mkdir --parent ${HOME}/.local/share/xfce4/terminal/colorschemes
ln --symbolic --force ${HOME}/.gruvbox-contrib/xfce4-terminal/*.theme \
    ${HOME}/.local/share/xfce4/terminal/colorschemes/

compose="docker compose --project-name desktop --file ${HOME}/.stack.yml"
${compose} pull
${compose} build --pull
${compose} up --remove-orphans --detach

echo "Enjoy!"
