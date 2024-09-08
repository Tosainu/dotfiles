if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  export $(systemctl --user show-environment | xargs)
  systemd-run --user --scope Hyprland
  systemctl --user start --job-mode=replace-irreversibly hyprland-session-shutdown.target
  exit
fi

if [ -n "$SSH_CONNECTION" ]; then
  export $(systemctl --user show-environment | xargs)
  if [ "$TERM" = alacritty ]; then
    export COLORTERM=truecolor
  fi
fi
