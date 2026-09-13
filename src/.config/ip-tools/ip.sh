get_host() {
  ip -4 -o a show scope global 2>/dev/null | head -n 1 | awk -F '[ /]+' '{print $4}' | tr -d '\n'
}

get_target() {
  local file="$(dirname -- "$0")/target.txt"
  if [[ -f "$file" ]]; then
    head -n 1 -- "$file" | tr -d '\n'
  fi
}

get_vpn() {
  ip -4 -o a show tun0 2>/dev/null | head -n 1 | awk -F '[ /]+' '{print $4}' | tr -d '\n'
}

copy_host() {
  get_host | wl-copy
  notify-send -a "$(basename -- "$0")" -u low -t 2500 'Copied host IP'
}

copy_target() {
  get_target | wl-copy
  notify-send -a "$(basename -- "$0")" -u low -t 2500 'Copied target IP'
}

copy_vpn() {
  get_vpn | wl-copy
  notify-send -a "$(basename -- "$0")" -u low -t 2500 'Copied VPN IP'
}

disp_ip() {
  if [[ -n "$1" ]]; then
    echo -n "$1 $2"
  fi
}

disp_host() {
  disp_ip "$(get_host)" ' '
}

disp_target() {
  disp_ip "$(get_target)" ' '
}

disp_vpn() {
  disp_ip "$(get_vpn)" '󰆧 '
}
