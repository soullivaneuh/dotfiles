selection=$(ghq list | rofi -dmenu -p "Project" -no-custom)

[[ ! -z "${selection}" ]] && code ${HOME}/p/${selection}

exit 0
