# source ../util.sh
source `realpath $(dirname $0)/../util.sh`

remove=`dots-remove-script $@`

# install
if [[ -z $remove ]]; then
    dots-file --file=$HOME/.bash_profile --grep='user/.bash_profile ]] &&' --append="[[ -f $lib/user/.bash_profile ]] && source $lib/user/.bash_profile"
    dots-link --link=$HOME/.gitconfig --target=$lib/user/.gitconfig --chmod=640
    dots-link --link=$HOME/.gitignore --target=$lib/user/.gitignore --chmod=640
    exit 0
fi

# remove
dots-file --file=$HOME/.bash_profile --grep='user/.bash_profile ]] &&' --remove
dots-remove $HOME/.gitconfig
dots-remove $HOME/.gitignore
