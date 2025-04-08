#!/bin/sh
# Global configuration and init

export PATH="${HOME}/bin:/usr/local/go/bin:${HOME}/.config/composer/vendor/bin:${PATH}"

export TERMINAL="alacritty"
export EDITOR="vi"
export VISUAL="view"
export FILE="ranger"
export READER="zathura"

export LESS="-R --no-init --quit-if-one-screen"
# @see https://unix.stackexchange.com/a/501164/173927
export LESS_TERMCAP_mb=$'\e[6m'
export LESS_TERMCAP_md=$'\e[34m'
export LESS_TERMCAP_us=$'\e[4;32m'
export LESS_TERMCAP_so=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[m'
export LESS_TERMCAP_ue=$'\e[m'
export LESS_TERMCAP_se=$'\e[m'

# NPM settings
# @see https://docs.npmjs.com/cli/using-npm/config
export npm_config_prefer_offline="true"
export npm_config_audit="false"
export npm_config_fund="false"

if [[ -f ~/.profile.local ]]; then
  source ~/.profile.local
fi

eval "$(hub alias -s)"

# Default numlock activation.
if [[ -x "$(command -v numlockx)" ]]; then
  numlockx on
fi

if [[ -f ~/.screenlayout/default.sh ]]; then
  sh ~/.screenlayout/default.sh
fi

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx

# Go path
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Another PATHS
export PATH="$PATH:$HOME/.local/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
