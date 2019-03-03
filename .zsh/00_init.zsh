# sub{u,g}id sets
# @see https://stackoverflow.com/q/54855737/1731473
SUBID="$(whoami):$(id -u):65536"
for conf in /etc/subuid /etc/subgid; do
  grep --quiet --line-regexp --fixed-strings -- ${SUBID} ${conf} \
    || sudo sed -i -n -e '/^sullivan:/!p' -e "\$a${SUBID}" ${conf}
done
