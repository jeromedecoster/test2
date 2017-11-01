# docker
# screenfetch
# virtualbox
# vlc
# asunder
# albert
# ack
# soulseekqt
# tesseract
# tesseract-data-fra
# tree

source `realpath $(dirname $0)/../util.sh`

remove=`dots-remove-script $@`

# install
if [[ -z $remove ]]; then
  while read name; do
    if [[ -z `pacman --query --quiet "$name" 2>/dev/null` ]]; then
      dots-log --info --bold=install --blue="$name" 'with yaourt'
      sudo yaourt --sync --noconfirm $name
    fi
  done <<EOF
ack
albert
asunder
docker
screenfetch
soulseekqt
tesseract
tesseract-data-fra
tree
virtualbox
visual-studio-code
vlc
EOF

  # clean pacman cache (yes 2 --verbose is required)
  if [[ -n `paccache --dryrun --verbose --verbose | grep ^/var` ]]; then
    dots-log --status=info "`bold clear` pacman cache"
    sudo paccache --remove
  fi
  exit 0
fi

# remove
while read name; do
    if [[ -n `pacman --query --quiet "$name" 2>/dev/null` ]]; then
      dots-log --info --bold=remove --blue="$name" 'with yaourt'
      sudo yaourt --remove --noconfirm $name
    fi
  done <<EOF
screenfetch
tree
EOF



#sudo paccache --dryrun --quiet


# nope... this is not good :)
#while read name; do
#  dots-log --status=info "`bold remove` orphan package `bold $name` with yaourt"
#  sudo yaourt --remove --noconfirm $name
#done < <(pacman --query --deps --unrequired --quiet)
#

# list of installed package with pacman
# pacman --query --quiet

# Mise à jour de la base, des paquets des dépôts plus ceux de AUR.
# yaourt -Syua

#-S, --sync
 #          Synchronize packages + AUR support, building from sources. See Sync
  #         Options.

#--force
 #          Force installation or updates.

#-a, --aur
 #          Also search in AUR database. With -u or --sysupgrade, upgrade aur
  #         packages that are out of date. With -Qm, display more info about
   #        foreign package.

#-u, --sysupgrade
 #          Upgrade all packages that are out of date.

# -U, --upgrade
 #          Upgrade or add package(s) to the system.

#--noconfirm
 #          Don’t ask for confirmation.

 #-R, --remove
      #     Remove package(s) from the system.

#--stats
 #          Show some statistics about your packages.

# filezilla

#sudo yaourt --remove --noconfirm tree
#sudo yaourt --sync --noconfirm tree

#### pacman pacman -Qdtq

#-Q, --query
#           Query the package database. This operation allows you to view
#           installed packages and their files, as well as meta-information
#           about individual packages (dependencies, conflicts, install date,
#           build date, size). This can be run against the local package
#           database or can be used on individual package files. In the first
#           case, if no package names are provided in the command line, all
#           installed packages will be queried. Additionally, various filters
#           can be applied on the package list. See Query Options below.
#-d, --deps
#           Restrict or filter output to packages installed as dependencies.
#           This option can be combined with -t for listing real orphans -
#           packages that were installed as dependencies but are no longer
#           required by any installed package.

#-t, --unrequired
#           Restrict or filter output to packages not required or optionally
#           required by any currently installed package. Specify this option
#           twice to only filter packages that are direct dependencies (i.e. do
#           not filter optional dependencies).

#-q, --quiet
#           Show less information for certain query operations. This is useful
#           when pacman’s output is processed in a script. Search will only
#           show package names and not version, group, and description
#           information; owns will only show package names instead of "file is
#           owned by pkg" messages; group will only show package names and omit
#           group names; list will only show files and omit package names;
#           check will only show pairs of package names and missing files; a
#           bare query will only show package names rather than names and
#           versions.

# pacman --query --deps --unrequired --quiet