#!/bin/sh
# Global configuration and init

export PATH="${HOME}/bin:${PATH}"

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

# @see https://github.com/jaagr/polybar/issues/339#issuecomment-447674287
export DEFAULT_NETWORK_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

if [[ -f ~/.profile.local ]]; then
  source ~/.profile.local
fi

eval "$(hub alias -s)"

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx
