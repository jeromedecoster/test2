export lib=/usr/local/lib/dots2

bold() {
  echo -e "\033[1m$1\033[0m"
}
ok() {
  #echo -e "\e[30;48;5;40m\e[38;5;15m  ok  \e[0m $1"
  echo -e "\e[30;48;5;40m\e[37;1m  OK  \e[0m $1"
}
info() {
  #echo -e "\e[30;48;5;32m\e[38;5;15m info \e[0m $1"
  echo -e "\e[30;48;5;32m\e[37;1m INFO \e[0m $1"
}
fail() {
  #echo -e "\e[30;48;5;196m\e[38;5;15m fail \e[0m $1"
  echo -e "\e[30;48;5;196m\e[37;1m FAIL \e[0m $1"
}
pa() {
  local name=`basename "$1"`
  local dirs=${1%$name}
  # is inside ~
    if [[ $HOME = ${dirs:0:${#HOME}} ]]; then
      echo -n "~${dirs:${#HOME}}"
    else
      echo -n "$dirs"
    fi
    # write name in bold blue
    echo -ne "\e[34;1m$name\e[0m"
    # if directory, add a trailing slash
    if [[ -d "$1" ]]; then
      echo -n /
    fi
}

path() {
  if [[ "$1" = '/' ]]; then
    echo -ne "\e[34;1m/\e[0m"
  else 
    local name=`basename "$1"`
    local dirs=${1%$name}
    # is inside ~
    if [[ $HOME = ${dirs:0:${#HOME}} ]]; then
      echo -n "~${dirs:${#HOME}}"
    else
      echo -n "$dirs"
    fi
    # write directory name in bold blue
    if [[ -d "$1" ]]; then
      echo -ne "\e[34;1m$name\e[0m/"
    # write symlink name in bold cyan
    elif [[ -L "$1" ]]; then
      echo -ne "\e[36;1m$name\e[0m"
    # write executable name in bold green
    elif [[ -x "$1" ]]; then
      echo -ne "\e[32;1m$name\e[0m"
    # write other name in bold white
    else
      echo -ne "\e[97;1m$name\e[0m"
    fi
  fi
}

# fail -n --status=ok|info|fail message

# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# \e[0m reset
# \e[1m bold
# \e[38;5;82m green
# \e[38;5;87m cyan
# \e[38;5;196m red
# \e[38;5;201m magenta
# \e[38;5;226m yellow

# green 82 | 34
# blue 87 (cyan) | 39
# red 196 | 124 (darker)
# magenta 201 | 129

# red          16 colors \e[31m
# red bright  256 colors \e[38;5;196m (better on dark)
# green        16 colors \e[32m (bad on white)
# green dark  256 colors \e[38;5;34m
# blue         16 colors \e[34m
# blue bright 256 colors \e[38;5;39m
# yellow       16 colors \e[33m (bad on white)
# cyan         16 colors \e[36m (bad on white)
# magenta     256 colors \e[38;5;201m
# orange      256 colors \e[38;5;202m (better than yellow)
dots-path() {
  local color='\e[38;5;39m' # blue bright
  local path=

  for arg in "$@"
  do
    if [[ ${arg:0:2} = '--' ]]; then
      case ${arg} in
        --color=none)    color='\e[0m' ;;
        --color=red)     color='\e[38;5;196m' ;;
        --color=green)   color='\e[38;5;34m'; ;;
        --color=magenta) color='\e[38;5;201m'; ;;
        --color=orange)  color='\e[38;5;202m'; ;;
      esac
    elif [[ -z $path ]]; then
      path=${arg}
    fi
  done

  [[ -z "$path" ]] && return

  local name=`basename "$path"`
  local dirs=`dirname "$path"`/

  #echo "color:$color"
  #echo "path:$path"
  #echo "name:$name"
  #echo "dirs:$dirs"
  # is inside ~
  if [[ $HOME = ${dirs:0:${#HOME}} ]]; then
    echo -n "~${dirs:${#HOME}}"
  else
    echo -n "$dirs"
  fi
    # write name in bold $color
  echo -ne "$color\e[1m$name\e[0m"
  # if directory, add a trailing slash
  [[ -d "$path" ]] && echo -n /

}

# dots-message --action=install " zgzg" --red="kok"

dots-log() {
  loop=0
  for arg in "$@"
  do
    (( loop++ ))
    case ${arg} in
      --ok) echo -e -n '\e[30;48;5;40m\e[37;1m  OK  \e[0m' ;;
      --info) echo -e -n '\e[30;48;5;32m\e[37;1m INFO \e[0m' ;;
      --fail) echo -e -n '\e[30;48;5;196m\e[37;1m FAIL \e[0m' ;;
      --bold=*) echo -e -n "\033[1m${arg:7}\033[0m" ;;
      --blue=*) echo -e -n "\e[38;5;39m\e[1m${arg:7}\e[0m" ;;
      --path=*) echo -n `dots-path ${arg:7}` ;;
      *) echo -n $arg ;;
    esac
      if [[ $loop -lt $# ]]; then
        echo -n ' '
      else 
        echo 
      fi
  done
}

dots-script() {
  for arg in "$@"
  do
    if [[ "$arg" = '--remove' ]]; then
      echo remove
      return
    fi
  done
  echo install
}

dots-remove-script() {
  for arg in "$@"
  do
    if [[ "$arg" = '--remove' ]]; then
      echo 1
      return
    fi
  done
}

dots-log0() {
  #local newline=1
  local message=
  local status='ok'

  for arg in "$@"
  do
    if [[ ${arg:0:2} = '--' ]]; then
      case ${arg} in
        #--newline=0) newline=0 ;;
        --status=info) status='info' ;;
        --status=fail) status='fail' ;;
      esac
    elif [[ -z $message ]]; then
      message=${arg}
    fi
  done

  case $status in
    ok)   echo -e  "\e[30;48;5;40m\e[37;1m  OK  \e[0m $message" ;;
    info) echo -e  "\e[30;48;5;32m\e[37;1m INFO \e[0m $message" ;;
    fail) echo -e "\e[30;48;5;196m\e[37;1m FAIL \e[0m $message" ;;
  esac
  
  #echo "opion newline:$newline"
  #echo "opion status:$status"
  #echo "message:$message"
  # Explode arguments (-Su -> -S -u, , --foo=bar -> --foo bar)
 # explode_args "$@"
  # Parse operation
#for ((i = 0; i < "${#OPTS[@]}"; i++)); do
#echo $i ${OPTS[$i]}
  #done
}


# dots-link --source= --link= --chmod=

dots-link() {
  #local newline=1
  local chmod=
  local link=
  local target=

  for arg in "$@"
  do
    if [[ ${arg:0:2} = '--' ]]; then
      case ${arg} in
        --chmod=*) chmod=${arg:8} ;;
        --link=*) link=${arg:7} ;;
        --target=*) target=${arg:9} ;;
      esac
    fi
  done

  [[ -z `echo "$chmod"| grep -E ^[0-7]{3}$` ]] && return
  [[ ! -e "$target" || -z "$link" ]] && return

  #echo "option chmod:$chmod:"
  #echo "option link:$link:"
  #echo "option target:$target:"

  if [[ -n $chmod ]]; then
    sudo chmod $chmod "$target"
  fi
  
  sudo rm --force "$link"
  sudo ln --symbolic "$target" "$link"

  status=--fail
  if [[ -L "$link" && `readlink --canonicalize "$link"` == "$target" ]]; then
      status=--ok
  fi
  #dots-log --status=$status "`bold 'symlink'` `dots-path $link` ➜ `dots-path $target`"
  dots-log $status --bold=symlink --path=$link '➜' --path=$target
}

dots-remove() {
  [[ ! -e "$1" ]] && return
  sudo rm -fr $1
  status=--fail
  [[ ! -e "$1" ]] && status=--ok
  dots-log $status --bold=remove --path=$1
}

dots-file() {
  local file=
  local grep=
  local append=
  local remove=

  for arg in "$@"
  do
    case ${arg} in
      --file=*) file=${arg:7} ;;
      --grep=*) grep=${arg:7} ;;
      --append=*) append=${arg:9} ;;
      --remove) remove=1 ;;
    esac
  done

  [[ -z "$file" || -z "$grep" ]] && return
  [[ ! -e "$file" ]] && touch "$file"

  local found=`cat "$file" | grep "$grep"`

  # append
  if [[ -n "$append" && -z "$found" ]]; then
      echo "$append" >> "$file"
      dots-log --ok --bold='append line' '➜' --path=$file

  # remove
  elif [[ -n "$remove" && -n "$found" ]]; then
    # escape slashes
    grep=`echo "$grep" | sed 's/\//\\\\\//g'`
    sed --in-place "/$grep/d" $file
    dots-log --ok --bold='remove line' '➜' --path=$file
  fi
}