#!/bin/sh

# EXPORT
# Simon Hugh Moore
#
# 

prefix=~/
password_store=~/.password-store    # location of password-store
gpg_id="$(cat "$password_store/.gpg-id")"       # get gpg-id from password-store
now="$(date '+%Y-%m-%d_%H-%M-%S_%P')"

package() {
    tar -zcf - -C "$password_store" --exclude ".passbk" ./ 
}

encrypt() {
    gpg -e -r "$gpg_id"
}


case "$1" in
    -p|--plain) shift; package > "$PWD/pass.$now.tar.gz" ;;
    -e|--encrypt) shift; package | encrypt > "$PWD/pass.$now.tar.gz.gpg" ;;
    *) package | encrypt > "$PWD/pass.$now.tar.gz.gpg" ;;
esac
exit 0
