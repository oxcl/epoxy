-- Epoxy — Minimal Hyprland config
-- Stripped down to bare essentials for AI agent-driven development

---- GENERAL ---------------------------
hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 0,
        layout      = "dwindle",
    },
})

---- DECORATION -------------------------
hl.config({
    decoration = {
        rounding       = 0,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = false,
        },

        blur = {
            enabled = false,
        },
    },
})

---- ANIMATIONS -------------------------
hl.config({
    animations = {
        enabled = false,
    },
})

---- INPUT ------------------------------
hl.config({
    input = {
        kb_layout     = "us",
        follow_mouse  = 1,
        sensitivity   = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

---- MISC -------------------------------
hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_hypr_splash     = true,
    },
})

---- KEYBINDS ---------------------------
local terminal = "foot"

hl.bind("SUPER + Return",  hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + Q",       hl.dsp.window.close())
hl.bind("SUPER + F",       hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + M",       hl.dsp.window.maximize())
hl.bind("SUPER + V",       hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + H",       hl.dsp.window.move("l"))
hl.bind("SUPER + J",       hl.dsp.window.move("d"))
hl.bind("SUPER + K",       hl.dsp.window.move("u"))
hl.bind("SUPER + L",       hl.dsp.window.move("r"))

---- AUTOSTART --------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
end)
