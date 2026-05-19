-- Monitors {{{

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

-- }}}

-- Autostart {{{

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("uwsm app -- fcitx5")
  hl.exec_cmd("uwsm app -- wl-paste --watch cliphist store")
end)

-- }}}

-- Environment Variables {{{

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- }}}

-- Variables {{{

hl.config({
  general = {
    border_size = 1,
    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    gaps_in = 0,
    gaps_out = 0,

    layout = "master",
  },

  decoration = {
    rounding = 0,
  },

  animations = {
    enabled = false,
  },

  master = {
    mfact = 0.5,
    new_on_top = true,
    new_status = "master",
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    disable_hyprland_guiutils_check = true,
    force_default_wallpaper = 0,
  },

  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },

  binds = {
    allow_workspace_cycles = true,
    drag_threshold = 10,
  },

  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "ctrl:nocaps",
    kb_rules = "",

    follow_mouse = 1,

    sensitivity = 0,

    touchpad = {
      disable_while_typing = true,
      tap_to_click = true,
      natural_scroll = true,
      middle_button_emulation = true,
      scroll_factor = 0.3,
    },
  },

  gestures = {
    workspace_swipe_cancel_ratio = 0.3,
    workspace_swipe_create_new = false,
  },
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- }}}

-- Key bindings {{{

-- frequently-used apps
hl.bind("SUPER + Return", hl.dsp.exec_cmd("uwsm app -- alacritty"))
hl.bind("SUPER + Backslash", hl.dsp.exec_cmd("uwsm app -- firefox"))
hl.bind("SUPER + Bracketright", hl.dsp.exec_cmd("uwsm app -- nautilus"))
hl.bind("SUPER + Slash", hl.dsp.exec_cmd("uwsm app -- gimp"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("uwsm app -- fuzzel"))

-- screenshot
hl.bind("Print", hl.dsp.exec_cmd("~/.local/bin/take_screenshot screen"))
hl.bind("CONTROL + Print", hl.dsp.exec_cmd("~/.local/bin/take_screenshot curwin"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.local/bin/take_screenshot selection"))

-- volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- brightness
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 1%- -n 1%"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +1% -n 1%"))

-- manipulate a master layout
hl.bind("SUPER + CONTROL + Return", hl.dsp.layout("swapwithmaster"))
hl.bind("SUPER + Space", hl.dsp.layout("orientationnext"))
hl.bind("SUPER + SHIFT + Space", hl.dsp.layout("orientationprev"))
hl.bind("SUPER + SHIFT + M", hl.dsp.layout("orientationleft"))
hl.bind("SUPER + J", hl.dsp.layout("cyclenext"))
hl.bind("SUPER + K", hl.dsp.layout("cycleprev"))
hl.bind("SUPER + SHIFT + J", hl.dsp.layout("swapnext"))
hl.bind("SUPER + SHIFT + K", hl.dsp.layout("swapprev"))
hl.bind("SUPER + SHIFT + H", hl.dsp.layout("addmaster"))
hl.bind("SUPER + SHIFT + L", hl.dsp.layout("removemaster"))
hl.bind("SUPER + L", hl.dsp.layout("mfact +0.01"), { repeating = true })
hl.bind("SUPER + H", hl.dsp.layout("mfact -0.01"), { repeating = true })
hl.bind("SUPER + M", hl.dsp.layout("mfact exact 0.5"), { repeating = true })

-- manipulate the focused window state
hl.bind("SUPER + SHIFT + C", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + CONTROL + Space", hl.dsp.window.float({ action = "toggle" }))

local workspace_keys = {
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "0",
  "Minus",
  "Equal",
}

for i, v in ipairs(workspace_keys) do
  -- switch to a workspace which is on the same monitor
  hl.bind("SUPER + " .. v, hl.dsp.focus({ workspace = "r~" .. i }))
  -- move the focused window to a workspace which is on the same monitor
  hl.bind("SUPER + SHIFT + " .. v, hl.dsp.window.move({ follow = false, workspace = "r~" .. i }))
  -- move the focused window to a workspace which is on the same monitor, then switch to there
  hl.bind("SUPER + CONTROL + " .. v, hl.dsp.window.move({ follow = true, workspace = "r~" .. i }))
end

-- switch to an adjacent workspace
hl.bind("SUPER + Right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + Left",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + SHIFT + Right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + SHIFT + Left",  hl.dsp.focus({ workspace = "r-1" }))

-- switch to the previous workspace
hl.bind("SUPER + Escape", hl.dsp.focus({ workspace = "previous_per_monitor" }))

-- switch to a workspace which is on an adjacent monitor
hl.bind("SUPER + CONTROL + J", hl.dsp.focus({ monitor = "+1" }))
hl.bind("SUPER + CONTROL + K", hl.dsp.focus({ monitor = "-1" }))

-- move the foused window to a workspace which is on an adjacent monitor
hl.bind("SUPER + SHIFT + O", hl.dsp.window.move({ follow = false, monitor = "+1" }))
hl.bind("SUPER + CONTROL + O", hl.dsp.window.move({ follow = true, monitor = "+1" }))

-- move a window to/from the "scratchpad"
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("minimized"))
hl.bind("SUPER + CONTROL + N", hl.dsp.window.move({ follow = false, workspace = "special:minimized" }))
hl.bind("SUPER + CONTROL + M", hl.dsp.window.move({ follow = true, workspace = "m+0" }))

-- resize/move a window by mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + CONTROL + mouse:272", hl.dsp.window.resize(), { mouse = true }) -- this was `resizewindow 2` (keepaspectratio)
hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- shutdown menu
hl.bind("SUPER + W", hl.dsp.exec_cmd("~/.local/bin/fuzzel-power-menu"))

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})

-- }}}

-- Windows and Workspaces {{{

hl.window_rule({
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  match = { class = "mpv" },
  float = true,
})

hl.window_rule({
  match = {
    initial_class = "(Vivado|ui-PlanAhead)",
    initial_title = "Vivado.*",
  },
  tile = true,
})

hl.window_rule({
  match = {
    initial_class = "(Vivado|ui-PlanAhead)",
    initial_title = "JidePopup",
  },
  no_initial_focus = true,
})

hl.window_rule({
  match = {
    initial_class = "firefox",
    initial_title = "Picture-in-Picture",
  },
  float = true,
  no_initial_focus = true,
  pin = true,
  size = { 720, 480 },
})


hl.workspace_rule({
  workspace = "special:minimized",
  gaps_in = 5,
  gaps_out = 20,
})

-- }}}

pcall(require, "hyprland-local")

-- vim: foldmethod=marker
