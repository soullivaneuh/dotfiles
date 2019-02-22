if [[ ! -a ~/.zplug ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
source ~/.zplug/init.zsh

LOAD_FLAGS=""
if ! zplug check --verbose; then
  LOAD_FLAGS="--verbose"
  zplug install
fi

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

zplug load ${LOAD_FLAGS}
