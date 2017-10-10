tmp=/tmp/dots
lib=/usr/local/lib/dots2

info() {
  echo -e "\e[30;48;5;32m\e[38;5;15m info \e[0m $1"
}
fail() {
  echo -e "\e[30;48;5;196m\e[38;5;15m fail \e[0m $1"
}

abort() {
  fail "$1"
  # ring
  echo -en "\007"
  exit 1
}

# Ask for sudo access if not already available
# Note: use `sudo -k` to loose sudo access
check_sudo() {
  # without sudo access return nothing
  if [[ -z `sudo -n uptime 2>/dev/null` ]]; then
    # sudo prompt
    info 'sudo access required...' 
    sudo echo >/dev/null
  fi
  # one more check if the user abort the password question
  [[ -z `sudo -n uptime 2>/dev/null` ]] && abort 'sudo required'
}


if [[ `git rev-parse --is-inside-work-tree 2>/dev/null` == 'true' ]]; then
    echo offline install
elif [[ `pwd` == '/tmp/dots' ]]; then
    echo /tmp/dots install
else
    echo online install
    mkdir -p /tmp/dots
    cd /tmp/dots
    curl -sSL https://github.com/jeromedecoster/test2/archive/master.tar.gz | tar zx --strip 1
    #bash ./install.sh
    # sudo needed
    check_sudo
    sudo cp -R $tmp $lib
fi