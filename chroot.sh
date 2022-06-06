#!/bin/bash

#colors:
RED='\033[31m'
GREEN='\033[32m'
NORMAL='\033[0m'
YELLOW='\033[33m'

echo -e "${YELLOW}Do you want to chroot to /mnt? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
read

if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
    sudo mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
    sudo mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
    sudo mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc
    sudo cp /etc/resolv.conf /mnt/etc
    sudo cp -r /${PWD} /mnt
    PS1='(chroot) # ' chroot /mnt /bin/bash