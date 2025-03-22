if [ "${XDG_VTNR}" -eq 1 ] && uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi

if [ -n "$SSH_CONNECTION" ]; then
  export $(systemctl --user show-environment | xargs)
  if [ "$TERM" = alacritty ]; then
    export COLORTERM=truecolor
  fi
fi
