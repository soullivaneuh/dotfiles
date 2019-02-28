HYPHEN_INSENSITIVE="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

export PATH="${HOME}:.zsh/bin:${HOME}/.gem/bin:${PATH}"

export EDITOR=vi
export VISUAL=view

export EMOJI_CLI_KEYBIND="^e"

export LESS="-R --no-init --quit-if-one-screen"

# @see https://unix.stackexchange.com/a/501164/173927
export LESS_TERMCAP_mb=$'\e[6m'
export LESS_TERMCAP_md=$'\e[34m'
export LESS_TERMCAP_us=$'\e[4;32m'
export LESS_TERMCAP_so=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[m'
export LESS_TERMCAP_ue=$'\e[m'
export LESS_TERMCAP_se=$'\e[m'

export TMUXIFIER_LAYOUT_PATH="${HOME}/.tmuxifier/layouts"

export ZPLUG_THREADS=64

setopt HIST_IGNORE_ALL_DUPS
