#!/bin/sh

# GEN
# Simon Hugh Moore
#
# wrapper for pass generate with sane options and prior backup

pass bk
pass generate -i $@
