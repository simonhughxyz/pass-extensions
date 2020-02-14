#!/bin/sh

# PASSBK
# Simon Hugh Moore
#

password_store="/home/simon/.password-store"    # location of password-store
bk_dir="$password_store/.passbk"           # location of root backup dir
gpg_id="$(cat "$password_store/.gpg-id")"       # get gpg-id from password-store
now="$(date '+%Y-%m-%d_%H-%M-%S_%P')"

backup(){
    # make backup directory if it doesent exit
    mkdir -m 0700 -p $1
    # Create tarball and encrypt it with gpg key used for password store
    tar -zcf - -C "$password_store" --exclude ".passbk" ./ | gpg -e -r "$gpg_id" -o "$1/pass.$now.tar.gz.gpg"
}

tmp(){
    local_bk_dir="$bk_dir/tmp"
    rm -f $local_bk_dir/*
    backup "$local_bk_dir" 
}

rolling(){
    local_bk_dir="$bk_dir/$1"
    shift
    for var in "$@"; do
        rm -f $local_bk_dir/pass.$var.tar.gz.gpg
    done
    backup "$local_bk_dir"
}

recoverbk(){
    bkdir="$XDG_RUNTIME_DIR/passrecoverbk"
    rm -rf $bkdir
    backup "$bkdir/bak/bak"
    cp "$HOME/.gnupg/pubring.gpg" "$bkdir/bak/bak/pubring.gpg"
    cp "$HOME/.gnupg/trustdb.gpg" "$bkdir/bak/bak/trustdb.gpg"

    tar -zcf - -C "$bkdir/bak/bak" ./ | gpg -e -r "$gpg_id" -o "$bkdir/bak/$now.tar.gz.gpg"
    rm -rf $bkdir/bak/bak

    cp "$HOME/.secret/key.asc" "$bkdir/bak/key.asc"
    tar -zcf $now.tar.gz -C "$bkdir/bak" ./ 
    rm -rf $bkdir/bak
    pass show shell/recoverpass | gpg --batch --yes --passphrase-fd 0 --output "$bkdir/pass" --armor --symmetric --cipher-algo AES256 $now.tar.gz
}

case "$1" in
    rolling) shift; rolling "$@";;
    dir) backup "$2";;
    tmp) tmp;;
    recoverbk) recoverbk;;
    *) tmp;;
esac
