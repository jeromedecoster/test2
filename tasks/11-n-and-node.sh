# source ../util.sh
source `realpath $(dirname $0)/../util.sh`

remove=`dots-remove-script $@`

# install
if [[ -z $remove ]]; then
    if [[ -z `which n 2>/dev/null` ]]; then
        dots-log --info --bold=install --blue=n 'and' --blue=node
        # install n and the latest version of node
        curl -L http://git.io/n-install | bash -s -- -y latest
    fi
    exit 0
fi

# remove
if [[ -n `which n-uninstall 2>/dev/null` ]]; then
    dots-log --info --bold=remove --blue=n 'and' --blue=node
    n-uninstall -y
fi