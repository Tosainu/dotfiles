if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  export $(run-parts /usr/lib/systemd/user-environment-generators | sed '/:$/d; /^$/d' | xargs)
  exec sway
fi
