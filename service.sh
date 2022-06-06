#!/bin/bash

#colors:
LGREEN='\033[1;32m'
NORMAL='\033[0m'

#This script helps you to managing your daemons

if [[ $1 = "up" ]]; then
    sudo sv up $2

elif [[ $1 = "down" ]]; then
    sudo sv down $2

elif [[ $1 = "restart" ]]; then
    sudo sv restart $2

elif [[ $1 = "status" ]]; then
    sudo sv status $2

elif [[ $1 = "help" || $1 = "-h" || $1 = "--help" || $1 = "h" ]]; then
    echo -e "${LGREEN}up       set your service up
down     set your service down
status   shows the status of your service
restart  restarts your service
add      adding your service to default level
delete   removes your service from default level
showas   shows available services
show     shows all services at the default level${NORMAL}"

elif [[ $1 = "showas" ]]; then
    ls /etc/sv

elif [[ $1 = "show" ]]; then
    ls /var/service

elif [[ $1 = "add" ]]; then
    sudo ln -s /etc/sv/$2 /var/service

elif [[ $1 = "delete" ]]; then
    sudo rm -r /var/service/$2

else
    echo -e "${LGREEN}Please enter 'service help'${NORMAL}"

fi
