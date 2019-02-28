[[ -x "$(command -v kompose)" ]] && source <(kompose completion zsh)
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion zsh)

CANI_COMPLETION_PATH="~/.config/cani/completions/_cani.zsh"
[[ -f ${CANI_COMPLETION_PATH} ]] && source ${CANI_COMPLETION_PATH}
