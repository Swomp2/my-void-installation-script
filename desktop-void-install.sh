#!/bin/bash

# colors:
RED='\033[31m'
GREEN='\033[32m'
LGREEN='\033[1;32m'
NORMAL='\033[0m'
YELLOW='\033[33m'
LYELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LMAGENTA='\033[1;35m'

if [[ `whoami` != "root" ]]; then
    clear
    echo -e "${RED}You should execute this script as root user or via sudo <[*_*]>${NORMAL}"
    exit
fi

clear

echo -e "${LYELLOW}This script helps you to install DE and some useful programs on your ${LGREEN}Void Linux ${LYELLOW}:3\n${NORMAL}"

#Chroot questions
#========================================================
echo -e "${YELLOW}Did you install your system via chroot? ${NORMAL}[${GREEN}N${NORMAL}/${RED}y${NORMAL}]"
read
if [[ $REPLY = "no" || $REPLY = "n" || $REPLY = "N" || $REPLY = "No" || $REPLY = "" || $REPLY = " " ]]; then

    echo -e "${YELLOW}Do you want to update your xbps? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
    read

    if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
        echo -e "${LBLUE}So I'll update your installed xbps now${NORMAL}"
        echo -e "${LMAGENTA}----------------------------------------"
        xbps-install -Su
        xbps-install -yu xbps
        echo -e "----------------------------------------${NORMAL}"
    fi
fi
#========================================================

#NetworkManager
#========================================================
echo -e "${YELLOW}Do you want to install NetworkManager? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
read

if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
    echo -e "${LMAGENTA}----------------------------------------"
    rm -r /etc/runit/runsvdir/default/dhcpcd
    rm -r /etc/runit/runsvdir/default/wpa_supplicant
    xbps-install NetworkManager -y
    ln -s /etc/sv/NetworkManager /etc/runit/runsvdir/default/
    echo -e "----------------------------------------${NORMAL}"
fi
#========================================================

#DBus
#========================================================
echo -e "${YELLOW}Do you want to put dbus in autorun? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
read
if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
    echo -e "${LMAGENTA}----------------------------------------"
    ln -s /etc/sv/dbus /etc/runit/runsvdir/default/
    echo -e "----------------------------------------${NORMAL}"
fi
#========================================================

#Elogind
#========================================================
echo -e "${YELLOW}Do you want to install elogind? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
read

if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then

    echo -e "${LBLUE}Now I'll install elogind${NORMAL}"
    echo -e "${LMAGENTA}----------------------------------------"
    xbps-install elogind -y
    echo -e "----------------------------------------${NORMAL}"

    echo -e "${YELLOW}Do you want to put elogind in autorun? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
    read

    if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
        echo -e "${LMAGENTA}----------------------------------------"
        ln -s /etc/sv/elogind /etc/runit/runsvdir/default/
        echo -e "----------------------------------------${NORMAL}"
    fi

fi
#========================================================

#Desktop Environment
#========================================================
echo -e "${YELLOW}Do you want to install any DE? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
read

if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then

    echo -e "${YELLOW}Which DE you want to install ${LMAGENTA}(kde5, gnome, xfce4, mate, lxde, lxqt)${NORMAL}${YELLOW}?${NORMAL}"
    read

    #KDE5
    #========================================================
    if [[ $REPLY = "kde5" ]]; then

        echo -e "\n${LBLUE}So, I'll install KDE for you :3${NORMAL}"
        echo -e "${LMAGENTA}----------------------------------------"
        xbps-install kde5 -y
        echo -e "----------------------------------------${NORMAL}"

        echo -e "${YELLOW}Do you want to install kde5-baseapps? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
        read

        if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
            echo -e "${LBLUE}Alright, I'll install base kde apps${NORMAL}"
            echo -e "${LMAGENTA}----------------------------------------"
            xbps-install kde5-baseapps -y
            echo -e "----------------------------------------${NORMAL}"
        fi

        echo -e "${YELLOW}Do you want to install sddm? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
        read

        if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
            echo -e "${LMAGENTA}----------------------------------------"
            xbps-install xorg-minimal
            xbps-install sddm
            ln -s /etc/sv/sddm /etc/runit/runsvdir/default
            echo -e "----------------------------------------${NORMAL}"
        else 

            echo -e "${LYELLOW}If you want to install another DM, you can enter the exact package name (or enter 'NO' for skip)"
            echo -e "You can find your DM by 'xbps-query -Rs <pkg name>' ;)${NORMAL}"
            read

            if [[ $REPLY != "NO" ]]; then
                echo -e "${LBLUE}So, I'll install ${REPLY} ${NORMAL}"
                echo -e "${LMAGENTA}----------------------------------------"
                xbps-install $REPLY -y
                ln -s /etc/sv/$REPLY /etc/runit/runsvdir/default/
                echo -e "----------------------------------------${NORMAL}"
            fi

        fi
    #========================================================

    #GNOME
    #========================================================
    elif [[ $REPLY = "gnome" ]]; then

        echo -e "\n${YELLOW}You can install ${GREEN}gnome${LMAGENTA}(includes base gnome apps)${YELLOW} or ${RED}gnome-core${YELLOW}. What you want to install? ${NORMAL}"
        read

        if [[ $REPLY = "gnome" ]]; then
            echo -e "${LBLUE}I'll install gnome${NORMAL}"
            echo -e "${LMAGENTA}----------------------------------------"
            xbps-install gnome -y
            echo -e "----------------------------------------${NORMAL}"

        elif [[ $REPLY = "gnome-core" ]]; then
            echo -e "${LBLUE}I'll install minimal gnome DE${NORMAL}"
            echo -e "${LMAGENTA}----------------------------------------"
            xbps-install gnome-core -y
            echo -e "----------------------------------------${NORMAL}"

        else
            echo -e "${RED}I don't know what is it :(${NORMAL}"

        fi

        echo -e "${YELLOW}Do you want to install gdm? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
        read

        if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
            echo -e "${LBLUE}Alright, I'll install gnome display manager${NORMAL}"
            echo -e "${LMAGENTA}----------------------------------------"
            xbps-install gdm -y
            ln -s /etc/sv/gdm /etc/runit/runsvdir/default/
            echo -e "----------------------------------------${NORMAL}"
        else
            echo -e "${LYELLOW}If you want to install another DM, you can enter the exact package name (or enter 'NO' for skip)"
            echo -e "You can find your DM by 'xbps-query -Rs <pkg name>' ;)${NORMAL}"
            read

            if [[ $REPLY != "NO" ]]; then
                echo -e "${LBLUE}So, I'll install ${REPLY} ${NORMAL}"
                echo -e "${LMAGENTA}----------------------------------------"
                xbps-install $REPLY -y
                ln -s /etc/sv/$REPLY /etc/runit/runsvdir/default/
                echo -e "----------------------------------------${NORMAL}"
            fi
        fi
    #========================================================

    #XFCE4
    #========================================================
    elif [[ $REPLY = xfce4 ]]; then
        echo -e "\n${LBLUE}Now I'll install XFCE for you :3${NORMAL}\n"

        echo -e "${LYELLOW}If you want to install any DM, you can enter the exact package name (or enter 'NO' for skip)"
        echo -e "You can find your DM by 'xbps-query -Rs <pkg name>' ;)${NORMAL}"
        read

        if [[ $REPLY != "NO" ]]; then
            echo -e "${LBLUE}So, I'll install ${REPLY} ${NORMAL}"
            echo -e "${LMAGENTA}----------------------------------------"
            xbps-install $REPLY -y
            ln -s /etc/sv/$REPLY /etc/runit/runsvdir/default/
            echo -e "----------------------------------------${NORMAL}"
        fi

        echo -e "${LBLUE}And finally I'll install XFCE(pkg)${NORMAL}"
        echo -e "${LMAGENTA}----------------------------------------"
        xbps-install xfce4 -y
        echo -e "----------------------------------------${NORMAL}"
    #========================================================

    #MATE
    #========================================================
    elif [[ $REPLY = "mate" ]]; then
        echo -e "\n${LBLUE}Alright, I'll install Mate for you :3${NORMAL}\n"

        echo -e "${LYELLOW}If you want to install any DM, you can enter the exact package name (or enter 'NO' for skip)"
        echo -e "You can find your DM by 'xbps-query -Rs <pkg name>' ;)${NORMAL}"
        read

        if [[ $REPLY != "NO" ]]; then
            echo -e "${LBLUE}So, I'll install ${REPLY} ${NORMAL}"
            echo -e "${LMAGENTA}----------------------------------------"
            xbps-install $REPLY -y
            ln -s /etc/sv/$REPLY /etc/runit/runsvdir/default/
            echo -e "----------------------------------------${NORMAL}"
        fi

        echo -e "${LBLUE}Now I'll install Mate(pkg)"
        echo -e "${LMAGENTA}----------------------------------------"
        xbps-install mate -y
        echo -e "----------------------------------------${NORMAL}"
    #========================================================

    #LXDE
    #========================================================
    elif [[ $REPLY = "lxde" ]]; then
        echo -e "\n${LBLUE}So, now I'll install LXDE :3${NORMAL}\n"

        echo -e "${YELLOW}Do you want to install LXDM? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
        read

        if [[ $REPLY = "no" || $REPLY = "n" || $REPLY = "N" || $REPLY = "No" ]]; then
            echo -e "${LYELLOW}If you want to install any DM, you can enter the exact package name (or enter 'NO' for skip)"
            echo -e "You can find your DM by 'xbps-query -Rs <pkg name>' ;)${NORMAL}"
            read

            if [[ $REPLY != "NO" ]]; then
                echo -e "${LBLUE}So, I'll install ${REPLY} ${NORMAL}"
                echo -e "${LMAGENTA}----------------------------------------"
                xbps-install $REPLY -y
                ln -s /etc/sv/$REPLY /etc/runit/runsvdir/default/
                echo -e "----------------------------------------${NORMAL}"
            fi
        else
            echo -e "${LBLUE}I'll install LXDM${NORMAL}"
            echo -e "${LMAGENTA}----------------------------------------"
            xbps-install lxdm -y
            ln -s /etc/sv/lxdm /etc/runit/runsvdir/default/
            echo -e "----------------------------------------${NORMAL}"

        fi

        echo -e "${LBLUE}Now I'll install LXDM(pkg)"
        echo -e "${LMAGENTA}----------------------------------------"
        xbps-install lxde -y
        echo -e "----------------------------------------${NORMAL}"
    #========================================================

    #LXQT
    #========================================================
    elif [[ $REPLY = "lxqt" ]]; then
        echo -e "\n${LBLUE}So, now I'll install LXQT :3${NORMAL}\n"

        echo -e "${YELLOW}Do you want to install lxdm? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
        read

        if [[ $REPLY = "no" || $REPLY = "n" || $REPLY = "N" || $REPLY = "No" ]]; then
            echo -e "${LYELLOW}If you want to install any DM, you can enter the exact package name (or enter 'NO' for skip)"
            echo -e "You can find your DM by 'xbps-query -Rs <pkg name>' ;)${NORMAL}"
            read

            if [[ $REPLY != "NO" ]]; then
                echo -e "${LBLUE}So, I'll install ${REPLY} ${NORMAL}"
                echo -e "${LMAGENTA}----------------------------------------"
                xbps-install $REPLY -y
                ln -s /etc/sv/$REPLY /etc/runit/runsvdir/default/
                echo -e "----------------------------------------${NORMAL}"
            fi
        else
            echo -e "${LBLUE}I'll install LXDM${NORMAL}"
            echo -e "${LMAGENTA}----------------------------------------"
            xbps-install lxdm -y
            ln -s /etc/sv/lxdm /etc/runit/runsvdir/default/
            echo -e "----------------------------------------${NORMAL}"

        fi

        echo -e "${LBLUE}Now I'll install LXQT(pkg)"
        echo -e "${LMAGENTA}----------------------------------------"
        xbps-install lxqt -y
        echo -e "----------------------------------------${NORMAL}"
    #========================================================

    else
        echo -e "${RED} I don't know what is it :("
    fi
fi
#========================================================

#pulseaudio
#========================================================
echo -e "${YELLOW}Do you want to install pulseaudio? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
read

if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
    echo -e "${LBLUE}Now I'll install pulseaudio for you${NORMAL}"
    echo -e "${LMAGENTA}----------------------------------------"
    xbps-install pulseaudio -y
    echo -e "----------------------------------------${NORMAL}"
else 
    echo -e "${LBLUE}So, you'll be without any sound${NORMAL}"
fi
#========================================================

#multilib repo
#========================================================
echo -e "${YELLOW}Do you want to install multilib repo? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
read

if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
    echo -e "${LMAGENTA}----------------------------------------"
    xbps-install void-repo-multilib -y 
    xbps-install -Syu
    echo -e "----------------------------------------${NORMAL}"
fi
#========================================================

#My "service" script install
#========================================================
echo -e "${YELLOW}Do you want to install my 'service' script? ${NORMAL}[${GREEN}Y${NORMAL}/${RED}n${NORMAL}]"
read

if [[ $REPLY = "yes" || $REPLY = "y" || $REPLY = "Y" || $REPLY = "Yes" || $REPLY = " " || $REPLY = "" ]]; then
    echo -e "${LBLUE}This script will help you in the future${NORMAL}"
    echo -e "${LMAGENTA}----------------------------------------"
    echo "Installation"
    cp /${PWD}/service /usr/bin
    echo -e "----------------------------------------${NORMAL}"
else
    echo -e "${LBLUE}So sad${NORMAL}"
fi
#========================================================

#Auto-delete Installation script
#========================================================
echo -e "${LBLUE}Auto-delete Installation script :)${NORMAL}"
echo -e "${LMAGENTA}----------------------------------------"
rm -r /${PWD}
echo -e "----------------------------------------${NORMAL}"
#========================================================

#The end
echo -e "${LYELLOW}Thank you for using my installation script :3${NORMAL}"
