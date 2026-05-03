#!/usr/bin/env bash

options="  Lock
󰍃  Logout
󰤄  Suspend
  Shutdown
  Reboot"

chosen=$(echo -e "$options" | wofi --dmenu \
  --prompt "Power Menu" \
  --style ~/.config/wofi-power/style.css \
  --width 400 \
  --height 350)

case "$chosen" in
    *Lock) loginctl lock-session ;;
    *Logout) hyprctl dispatch exit ;;
    *Suspend) systemctl suspend ;;
    *Shutdown) systemctl poweroff ;;
    *Reboot) systemctl reboot ;;
esac
