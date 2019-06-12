source ~/.shrc

TMP_PATH=/tmp/${USER}/zsh
UPDATE_LOCK=${TMP_PATH}/update.lock
mkdir --parent ${TMP_PATH}
if [[ ! -f ${UPDATE_LOCK} ]]; then
  touch ${UPDATE_LOCK}
  echo "Update: Dotfiles"
  cd ~/p/github.com/soullivaneuh/dotfiles && make update deploy && cd -
fi

if [[ ! -a ~/.zplug ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

if [[ ! -a ~/.tmux/plugins/tpm ]]; then
  mkdir --parent ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
source ~/.zplug/init.zsh

LOAD_FLAGS=""
if ! zplug check --verbose; then
  LOAD_FLAGS="--verbose"
  zplug install
fi

source ~/.alias

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

zplug load ${LOAD_FLAGS}

eval "$(tmuxifier init -)"

cowsay $(curl -s https://jerome1337.o6s.io/henri-facts | jq ".text")
