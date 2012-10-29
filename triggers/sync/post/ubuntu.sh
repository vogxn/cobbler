#!/bin/bash
set -x
libdir=/var/lib/cobbler
srcdir=/var/www/cobbler
dstdir=/tftpboot

for file in $( grep -l precise $dstdir/pxelinux.cfg/* ); do
   sed -i -e 's/auto/auto\=true\ netcfg\/choose_interface\=eth0/g' $file 
done
