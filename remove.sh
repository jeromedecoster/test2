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

# todo : abort if no dir

if [[ ! -d $lib ]]; then
    echo ABORT
fi


if [[ `pwd` == $lib ]]; then
    echo remove
    # sudo needed
    check_sudo
    while read file; do
        #echo $lib/tasks/$file
        bash $lib/tasks/$file ji --remove ko
    # only catch the files who starts with a number (for easy deactivation) and finish with .sh
    done < <(ls -1 $lib/tasks | grep ^[0-9].*sh$)
elif [[ `git rev-parse --is-inside-work-tree 2>/dev/null` == 'true' ]]; then
    echo remove from git
    check_sudo
    sudo rm --force --recursive $lib
    sudo mkdir --parents $lib
    sudo cp --recursive `ls -A1 | grep -v .git` $lib
    sudo chown --recursive `whoami` $lib
    cd $lib
    bash ./remove.sh
fi