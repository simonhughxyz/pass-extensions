#!/bin/sh

# EXPORT
# Simon Hugh Moore
#
# 

prefix=~/
password_store=~/.password-store    # location of password-store
gpg_id="$(cat "$password_store/.gpg-id")"       # get gpg-id from password-store

package() {
    tar -zcf - -C "$password_store" --exclude ".passbk" ./ 
}

encrypt() {
    gpg -e -r "$gpg_id"
}
