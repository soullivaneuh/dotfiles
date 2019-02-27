# ALT-C - Fuzzy commands
fzf-project-widget() {
  local cmd="(find -L . -mindepth 1 ; ghq list) 2> /dev/null"
  setopt localoptions pipefail 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  cd "${HOME}/p/$dir"
  local ret=$?
  zle fzf-redraw-prompt
  return $ret
}
zle     -N    fzf-project-widget
bindkey '\ec' fzf-project-widget
