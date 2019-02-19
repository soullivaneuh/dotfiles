if [[ ! -a ~/.zplug ]]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source ~/.zplug/init.zsh

if ! zplug check --verbose; then
    zplug install
fi

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

zplug load --verbose
