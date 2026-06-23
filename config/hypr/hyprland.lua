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
        disable_xdg_env_checks  = true,
    },
})

---- AUTOSTART --------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("foot")
end)
