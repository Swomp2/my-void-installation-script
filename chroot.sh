#!/bin/bash

#colors:
RED='\033[31m'
GREEN='\033[32m'
NORMAL='\033[0m'
YELLOW='\033[33m'

#check for root 
#========================================================
if [[ `whoami` != "root" ]]; then
    clear
    echo -e "${RED}You should execute this script as root user or via sudo <[*_*]>${NORMAL}"
    exit
fi
#========================================================

#create /mnt/boot
#========================================================
echo -e "${YELLOW}I can create a mount point /mnt/boot or /mnt/boot/efi${NORMAL}<-${YELLOW}(default). What point you need?${NORMAL}"
read

mount_point=${REPLY}

if [[ $REPLY = "/mnt/boot/efi" || $REPLY = " " || $REPLY = "" ]]; then
    sudo mkdir /mnt/boot && sudo mkdir /mnt/boot/efi
else 
    sudo mkdir /mnt/boot
fi
#========================================================

#mount to /mnt/boot
#========================================================
echo -e "${YELLOW}Which partition should be mounted in ${REPLY}?${NORMAL}"
read

sudo mount ${REPLY} ${mount_point}
#========================================================

#mount to /mnt
#========================================================
echo -e "${YELLOW}Which partition should be mounted in /mnt?${NORMAL}"
read

sudo mount ${REPLY} /mnt
#========================================================

#chroot
#========================================================
echo -e "${YELLOW}Do you want to chroot to /mnt? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
read

if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
    sudo mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
    sudo mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
    sudo mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc
    sudo cp /etc/resolv.conf /mnt/etc
    sudo cp -r /${PWD} /mnt
    PS1='(chroot) # ' chroot /mnt /bin/bash
fi
#========================================================
