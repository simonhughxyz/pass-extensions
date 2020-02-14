#!/bin/sh

# EXPORT
# Simon Hugh Moore
#
# 

password_store=~/.password-store    # location of password-store

package() {
    tar -zcf - -C "$password_store" --exclude ".passbk" ./ 
}
