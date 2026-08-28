#!/bin/bash

getHostIp() {
    ip -4 -o a show scope global 2>/dev/null | head -n 1 | awk -F '[ /]+' '{print $4}' | tr -d '\n'
}

getTargetIp() {
    cat $HOME/.config/waybar/target.txt
}

getVpnIp() {
    ip -4 -o a show tun0 2>/dev/null | head -n 1 | awk -F '[ /]+' '{print $4}' | tr -d '\n'
}

copyHostIp() {
    getHostIp | wl-copy
    notify-send -a 'ip.sh' -u low -t 2500 'Copied host IP'
}

copyTargetIp() {
    getTargetIp | wl-copy
    notify-send -a 'ip.sh' -u low -t 2500 'Copied target IP'
}

copyVpnIp() {
    getVpnIp | wl-copy
    notify-send -a 'ip.sh' -u low -t 2500 'Copied VPN IP'
}

dispIp() {
    if [[ -n "$1" ]]; then
        echo -n "$1 $2"
    fi
}

dispHostIp() {
    dispIp "$(getHostIp)" " "
}

dispTargetIp() {
    dispIp "$(getTargetIp)" " "
}

dispVpnIp() {
    dispIp "$(getVpnIp)" "󰆧 "
}
