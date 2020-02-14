#!/bin/sh

# GET
# Simon Hugh Moore
#
# Retrive meta data from pass file
# 
# Meta data must be organized in file like so:
# meta_name: data
# for example:
# login: user_name

get(){
    pass show "$2" | rg "$1: " | cut -d' ' -f2
}

case "$2" in
    -c) get "$1" "$3" | xclip -selection clipboard;;
    *) get "$@";;
esac

