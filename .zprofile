if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  export $(systemctl --user show-environment | xargs)
  exec systemd-run --user --scope Hyprland
fi
