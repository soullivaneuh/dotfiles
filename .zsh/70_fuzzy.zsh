# ALT-C - Fuzzy commands
fzf-project-widget() {
  local find_opts="-L"
  local find_predicates="-mindepth 1"
  local cmd="(
    find ${find_opts} . ${find_predicates}
    ;
    ghq list
    ;
    find ${find_opts} ~ ${find_predicates} -and -not -path '$(pwd)/*'
    ;
    find ${find_opts} /etc ${find_predicates}
  ) 2> /dev/null"
  setopt localoptions pipefail 2> /dev/null
  local line="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"

  if [[ -z "${line}" ]]; then
    zle redisplay
    return 0
  fi

  local project_dir="${HOME}/p/$line"
  [[ -d "${project_dir}" ]] && line=${project_dir}

  if [[ -d "${line}" ]]; then
    cd ${line}
  elif [[ -x "${line}" ]]; then
    ${line}
  elif [[ -f "${line}" ]]; then
    ${EDITOR} ${line}
  else
    echo "Nothing to do for ${line}" && false
  fi

  local ret=$?
  zle fzf-redraw-prompt
  return ${ret}
}
zle     -N    fzf-project-widget
bindkey '\ec' fzf-project-widget
