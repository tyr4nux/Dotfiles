#!/bin/bash

option=$(echo -n -e '1 - Shutdown\n2 - Reboot\n3 - Suspend\n4 - Lockdown' | fuzzel --dmenu -l 4 --mesg='Power Menu')

case $option in
    *"Shutdown")
        systemctl poweroff
        ;;
    *"Reboot")
        systemctl reboot
        ;;
    *"Suspend")
        systemctl suspend
        ;;
    *"Lockdown")
        loginctl lock-session
        ;;
esac
