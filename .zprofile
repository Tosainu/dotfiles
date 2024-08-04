if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  export $(systemctl --user show-environment | xargs)
  exec systemd-run --user --scope Hyprland
fi

if [ -n "$SSH_CONNECTION" ]; then
  export $(systemctl --user show-environment | xargs)
  if [ "$TERM" = alacritty ]; then
    export COLORTERM=truecolor
  fi
fi
