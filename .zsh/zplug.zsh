zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh"

zplug "~/.zsh", from:local, use:"*_*.zsh"

zplug "b4b4r07/emoji-cli"
zplug "GoogleContainerTools/skaffold", as:command, from:gh-r, rename-to:skaffold
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
zplug "junegunn/fzf", use:"shell/*.zsh", defer:2
zplug "motemen/ghq", as:command, from:gh-r, rename-to:ghq
zplug "motemen/ghq", use:"zsh"
zplug "mrowa44/emojify", as:command
zplug "stedolan/jq", as:command, from:gh-r, rename-to:jq

zplug "plugins/capistrano", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/cp", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/emoji", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/helm", from:oh-my-zsh
zplug "plugins/history", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh

zplug "caarlos0/git-add-remote"
zplug "paulirish/git-open"
zplug "wfxr/forgit"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3

zplug "denysdovhan/spaceship-prompt", as:theme
