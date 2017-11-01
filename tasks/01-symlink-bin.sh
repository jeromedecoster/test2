#echo je suis 01
# the default $PATH /usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
#sudo chmod 750 /usr/local/lib/dots2/bin/git-aaa.sh
#sudo rm -f /usr/local/bin/git-aaa
#sudo ln -s /usr/local/lib/dots2/bin/git-aaa.sh /usr/local/bin/git-aaa

#lib=/usr/local/lib/dots2
bin=/usr/local/bin

# source ../util.sh
source `realpath $(dirname $0)/../util.sh`

remove=`dots-remove-script $@`

while read file; do

    # install
    if [[ -z $remove ]]; then
        dots-link --link=/usr/local/bin/$file --target=$lib/bin/$file --chmod=750
        continue
    fi

    # remove
    dots-remove /usr/local/bin/$file

done < <(ls -1 $lib/bin)