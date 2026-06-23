# Hyprland Guide for AI Agents

> **Version**: v0.55.4 (June 2026) | **Config System**: Lua (since v0.55)

## What is Hyprland?

Hyprland is a dynamic tiling Wayland compositor known for its animations, customizability, and plugin system. Unlike static tiling WMs, Hyprland supports floating windows, smooth animations, and extensive configuration through Lua scripts.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Configuration System (Lua)](#configuration-system-lua)
3. [Key Concepts](#key-concepts)
4. [Plugin System](#plugin-system)
5. [Ecosystem Tools](#ecosystem-tools)
6. [Common Tasks](#common-tasks)
7. [Documentation Links](#documentation-links)

---

## Architecture Overview

Hyprland runs as a Wayland compositor. Key architectural components:

- **Compositor Core** (`hyprland`) - The main binary handling window management, rendering, input
- **IPC** (`hyprctl`) - Command-line tool for runtime control
- **Lua Config** - Configuration and scripting via Lua
- **Plugin API** - C++ API for extending functionality
- **Ecosystem** - Companion tools (hyprpaper, hyprlock, hypridle, etc.)

### Key Directories

| Path | Purpose |
|------|---------|
| `~/.config/hypr/hyprland.lua` | Main configuration file |
| `/usr/share/hypr/stubs/` | Lua LSP stubs for autocompletion |
| `/usr/lib/hyprland/` | Plugin `.so` files |
| `~/.local/share/hypr/` | Runtime data |

---

## Configuration System (Lua)

Since v0.55, Hyprland uses **Lua** for configuration, replacing the legacy `hyprlang` syntax.

### Config File Location

```
~/.config/hypr/hyprland.lua
```

### The `hl` Global Namespace

All Hyprland functionality is exposed through the `hl` global table:

| Function | Purpose |
|----------|---------|
| `hl.config({...})` | Set global configuration |
| `hl.monitor({...})` | Configure monitors |
| `hl.bind(key, action)` | Register keybinds |
| `hl.window_rule({...})` | Define window rules |
| `hl.layer_rule({...})` | Define layer rules |
| `hl.on(event, callback)` | Register event callbacks |
| `hl.env(key, value)` | Set environment variables |
| `hl.permission(...)` | Set permissions |
| `hl.exec_cmd(cmd)` | Execute shell command |

### Dispatcher Table

Access dispatchers via `hl.dsp`:

```lua
hl.dsp.window.close()          -- Close window
hl.dsp.window.float()          -- Toggle float
hl.dsp.window.move(x, y)       -- Move window
hl.dsp.workspace.next()        -- Next workspace
hl.dsp.exec_cmd("kitty")      -- Launch terminal
```

### Example Configuration

```lua
-- ~/.config/hypr/hyprland.lua

-- Monitors
hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@144",
    position = "0x0",
    scale    = 1,
})

-- Global Config
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border   = "rgba(33ccffee) rgba(00ff99ee) 45deg",
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
        },
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
    },
    animations = {
        enabled = true,
    },
})

-- Keybinds
local terminal = "kitty"
hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + M", hl.dsp.window.maximize())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + SHIFT + 1-9", hl.dsp.workspace({ id = "+1" }))

-- Window Rules
hl.window_rule({
    name  = "float-gui",
    match = { class = "firefox" },
    float = true,
    size  = { 1200, 800 },
    center = true,
})

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar &")
    hl.exec_cmd("hyprpaper &")
    hl.exec_cmd(terminal)
end)

-- Event Callbacks
hl.on("window.active", function(w)
    -- Handle window focus
end)

hl.on("config.reloaded", function()
    hl.notification.create({ text = "Config reloaded!", timeout = 3000 })
end)
```

### Splitting Config Across Files

Use Lua's `require()` to modularize:

```lua
-- hyprland.lua
require("keybinds")
require("monitors")
require("window-rules")
```

Each `require()` runs in a separate Lua scope for error isolation.

### Available Events (`hl.on()`)

| Event | Parameters |
|-------|------------|
| `hyprland.start` | None |
| `hyprland.shutdown` | None |
| `window.open` | Window |
| `window.close` | Window |
| `window.active` | Window, int (0/1) |
| `window.urgent` | Window |
| `window.title` | Window |
| `window.fullscreen` | Window |
| `window.move_to_workspace` | Window, Workspace |
| `layer.opened` | LayerSurface |
| `layer.closed` | LayerSurface |
| `monitor.added` | Monitor |
| `monitor.removed` | Monitor |
| `monitor.focused` | Monitor |
| `workspace.active` | Workspace |
| `workspace.created` | Workspace |
| `workspace.removed` | Workspace |
| `config.reloaded` | None |
| `keybinds.submap` | String (submap name) |

### Querying State

```lua
-- Get current values
local win = hl.get_active_window()
local ws = hl.get_active_workspace()
local mon = hl.get_active_monitor()
local cursor = hl.get_cursor_pos()

-- Lists
local all_windows = hl.get_windows()
local all_workspaces = hl.get_workspaces()
local all_monitors = hl.get_monitors()

-- Config values
local gaps = hl.get_config("general.gaps_in")
```

### Custom Layouts (v0.55+)

Define layouts directly in Lua:

```lua
hl.layout.register("columns", {
    recalculate = function(ctx)
        local n = #ctx.targets
        if n == 0 then return end
        for i, target in ipairs(ctx.targets) do
            target:place(ctx:column(i, n))
        end
    end,
})

-- Use it in config
hl.config({
    general = { layout = "lua:columns" },
})
```

### LSP Setup

Configure VS Code for autocompletion:

```json
// .luarc.json
{
  "workspace": {
    "library": ["/usr/share/hypr/stubs"]
  }
}
```

### Error Behavior

| Error Type | Result |
|------------|--------|
| Fundamental syntax errors | Config reload refused; error bar shown |
| Runtime syntax errors | Current scope aborted; error shown |
| Hyprland type errors | Execution continues; error shown |
| Async errors (callbacks) | Notification popup |

Emergency keybinds on major errors:
- `SUPER+Q` - Open terminal
- `SUPER+R` - Run prompt
- `SUPER+M` - Exit Hyprland

---

## Key Concepts

### Workspaces

Virtual desktops. Workspaces are numbered or named. Use rules to assign apps to specific workspaces.

```lua
hl.window_rule({
    name = "browser-ws",
    match = { class = "firefox" },
    workspace = 2,
})
```

### Floating vs Tiling

Windows can be floating or tiled. Toggle with keybind:

```lua
hl.bind("SUPER + SPACE", hl.dsp.window.float({ action = "toggle" }))
```

### Window Rules

Conditional rules for window behavior. Match by class, title, tag, etc.

```lua
hl.window_rule({
    name = "float-dialog",
    match = {
        class = ".*",
        title = "Open File",
        dialog = true,  -- Match dialog windows
    },
    float = true,
    center = true,
    size = { 600, 400 },
})
```

### Layer Rules

For Wayland layer surfaces (bars, overlays):

```lua
hl.layer_rule({
    name = "waybar-above",
    match = { namespace = "waybar" },
    layer = "overlay",
    blur = { enabled = false },
    ignore_opacity = true,
})
```

### Layouts

Built-in layouts: `dwindle`, `master`, `scrolling`, `monocle`.

```lua
hl.config({
    general = {
        layout = "dwindle",
    },
    dwindle = {
        pseudotile = false,
        force_split = 0,
        preserve_split = false,
    },
})
```

### Submaps

Named keybind groups for modal workflows:

```lua
hl.bind("SUPER, P", hl.dsp.submap.enter({ name = "resize" }))
-- In resize mode:
hl.bind("h", hl.dsp.window.resize({ width = "-20", height = "0" }))
hl.bind("l", hl.dsp.window.resize({ width = "+20", height = "0" }))
hl.bind("escape", hl.dsp.submap.exit())
```

---

## Plugin System

### Plugin Manager (`hyprpm`)

```bash
# Update plugin manager
hyprpm update

# Add a plugin repository
hyprpm add https://github.com/hyprwm/hyprland-plugins

# List available plugins
hyprpm list

# Enable a plugin
hyprpm enable <plugin-name>

# Reload plugins
hyprpm reload
```

### Manual Plugin Loading

```bash
# Load
hyprctl plugin load /path/to/plugin.so

# Unload
hyprctl plugin unload /path/to/plugin.so

# List loaded
hyprctl plugin list
```

### Plugin Development

#### Required Files

```
my-plugin/
  src/
    main.cpp
  hyprpm.toml
  Makefile
```

#### Plugin Structure (C++)

```cpp
#include <hyprland/src/plugins/PluginAPI.hpp>

inline HANDLE PHANDLE = nullptr;

// API version check (required)
APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

// Plugin init (required)
APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    // Version mismatch check
    const std::string COMPOSITOR_HASH = __hyprland_api_get_hash();
    const std::string CLIENT_HASH = __hyprland_api_get_client_hash();
    if (COMPOSITOR_HASH != CLIENT_HASH) {
        HyprlandAPI::addNotification(PHANDLE, "[MyPlugin] Mismatched headers!",
                                     CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
        throw std::runtime_error("[MyPlugin] Version mismatch");
    }

    // Register config values
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:myPlugin:enabled", SConfigValue{.intValue = 1});

    // Register custom hyprctl command
    HyprlandAPI::registerHyprCtlCommand(PHANDLE, "my-command", [](std::string arg) {
        return "Result: " + arg;
    });

    return {"MyPlugin", "Description", "Author", "1.0"};
}

// Optional: Cleanup
APICALL EXPORT void PLUGIN_EXIT() {
    // Cleanup handled by Hyprland
}
```

#### Key Plugin API Functions

| Function | Purpose |
|----------|---------|
| `HyprlandAPI::addConfigValue()` | Register plugin config (in `plugin:` namespace) |
| `HyprlandAPI::getConfigValue()` | Read config values |
| `HyprlandAPI::addNotification()` | Show notification popups |
| `HyprlandAPI::findFunctionsByName()` | Find internal functions for hooking |
| `HyprlandAPI::createFunctionHook()` | Hook internal functions |
| `HyprlandAPI::addLuaFunction()` | Register Lua functions |
| `HyprlandAPI::addEvent()` | Add custom events |
| `HyprlandAPI::registerHyprCtlCommand()` | Register custom hyprctl commands |
| `Event::bus()` | Access event bus for hooks |

#### Function Hooks

Hook internal Hyprland functions (x86_64 only):

```cpp
inline CFunctionHook* g_pHook = nullptr;
typedef void (*origFunc)(void*, void*);

void hkFunc(void* owner, void* data) {
    // Before original
    (*(origFunc)g_pHook->m_pOriginal)(owner, data);
    // After original
}

// In PLUGIN_INIT:
static const auto METHODS = HyprlandAPI::findFunctionsByName(PHANDLE, "listener_monitorFrame");
g_pHook = HyprlandAPI::createFunctionHook(handle, METHODS[0].address, (void*)&hkFunc);
g_pHook->hook();
```

#### Event Hooks (Preferred)

Subscribe to events via `Event::bus()`:

```cpp
// Subscribe to events
Event::bus().hook([](void* owner, SCallbackInfo& info, const std::any& data) {
    // Handle event
}, "activeWindow");
```

Available events: `tick`, `activeWindow`, `activeLayout`, `render`, `keyPress`, etc.

#### hyprpm.toml Manifest

```toml
[repository]
name = "MyPlugin"
authors = ["Me"]
commit_pins = [
    ["hyprland_hash", "plugin_hash"],
]

[my-plugin]
description = "Plugin description"
authors = ["Me"]
output = "my-plugin.so"
build = ["make all"]
```

### Official Plugins

| Plugin | Description |
|--------|-------------|
| `borders-plus-plus` | Additional window borders |
| `hyprbars` | Title bars |
| `hyprexpo` | Workspace overview |
| `hyprfocus` | Flashfocus effect |
| `hyprscrolling` | Scrolling layout |
| `hyprtrails` | Smooth trails behind windows |
| `hyprwinwrap` | App as wallpaper |
| `xtra-dispatchers` | Additional dispatchers |

### Community Plugins

- **hy3** - i3-like manual tiling
- **hyprscroller** - Alternative scrolling layout
- **Hyprspace** - Workspace overview
- **split-monitor-workspaces** - Per-monitor workspaces
- **hycov** - Grid view

---

## Ecosystem Tools

| Tool | Purpose | Docs |
|------|---------|------|
| `hyprpaper` | Wallpaper manager | https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/ |
| `hyprlock` | Lock screen | https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/ |
| `hypridle` | Idle daemon | https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/ |
| `hyprpicker` | Color picker | https://wiki.hyprland.org/Hypr-Ecosystem/hyprpicker/ |
| `hyprlauncher` | App launcher | https://wiki.hyprland.org/Hypr-Ecosystem/hyprlauncher/ |
| `hyprsunset` | Night mode | https://wiki.hyprland.org/Hypr-Ecosystem/hyprsunset/ |
| `hyprtoolkit` | GUI toolkit | https://wiki.hyprland.org/Hypr-Ecosystem/hyprtoolkit/ |
| `hyprcursor` | Cursor themes | https://wiki.hyprland.org/Hypr-Ecosystem/hyprcursor/ |
| `waybar` | Status bar | https://github.com/Alexays/Waybar |
| `rofi-wayland` | App launcher | https://github.com/lbonn/rofi |

---

## Common Tasks

### Change Default Terminal

```lua
local terminal = "kitty"
hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
```

### Set Wallpaper

```bash
hyprctl dispatch exec "hyprpaper -i /path/to/wallpaper.jpg"
```

Or with config file `~/.config/hypr/hyprpaper.conf`:
```
preload = /path/to/wallpaper.jpg
wallpaper = , /path/to/wallpaper.jpg
```

### Create Custom Keybind

```lua
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("rofi -show drun"))
```

### Float Specific Windows

```lua
hl.window_rule({
    name = "float-calculator",
    match = { class = "gnome-calculator" },
    float = true,
    size = { 300, 400 },
    center = true,
})
```

### Auto-Assign Workspace

```lua
hl.window_rule({
    name = "browser-ws2",
    match = { class = "^firefox$" },
    workspace = 2,
})
```

### Reload Config

```bash
hyprctl reload
```

### Debug

```bash
# Check Hyprland version
hyprctl version

# Get window info
hyprctl clients

# Get monitor info
hyprctl monitors

# Check logs
journalctl --user -u hyprland
```

---

## Documentation Links

### Official

| Resource | URL |
|----------|-----|
| **Wiki (Primary)** | https://wiki.hypr.land/ |
| **GitHub (Source)** | https://github.com/hyprwm/Hyprland |
| **Plugin API Header** | https://github.com/hyprwm/Hyprland/blob/main/src/plugins/PluginAPI.hpp |
| **Example Config** | https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua |
| **Wiki Source** | https://github.com/hyprwm/hyprland-wiki |
| **Release Notes** | https://github.com/hyprwm/Hyprland/releases |

### Wiki Sections

| Topic | URL |
|-------|-----|
| Installation | https://wiki.hypr.land/Getting-Started/Installation/ |
| Master Tutorial | https://wiki.hypr.land/Getting-Started/Master-Tutorial/ |
| Lua Config Start | https://wiki.hypr.land/Configuring/Start/ |
| Configuration Basics | https://wiki.hypr.land/Configuring/Basics/ |
| Binds | https://wiki.hypr.land/Configuring/Basics/Binds/ |
| Window Rules | https://wiki.hypr.land/Configuring/Basics/Window-Rules/ |
| Layouts | https://wiki.hypr.land/Configuring/Layouts/ |
| Custom Layouts | https://wiki.hypr.land/Configuring/Layouts/Custom-Layouts/ |
| Animations | https://wiki.hypr.land/Configuring/Advanced-and-Cool/ |
| Plugins (Using) | https://wiki.hypr.land/Plugins/Using-Plugins/ |
| Plugins (Dev - Getting Started) | https://wiki.hypr.land/Plugins/Development/Getting-Started/ |
| Plugins (Dev - Guidelines) | https://wiki.hypr.land/Plugins/Development/Plugin-Guidelines/ |
| Plugins (Dev - Advanced) | https://wiki.hypr.land/Plugins/Development/Advanced/ |
| Example Configs | https://wiki.hypr.land/Configuring/Example-configurations/ |

### Community

| Resource | URL |
|----------|-----|
| Awesome Hyprland | https://github.com/hyprland-community/awesome-hyprland |
| Featured Plugins | https://hypr.land/plugins/ |
| Official Plugins | https://github.com/hyprwm/hyprland-plugins |
| ArchWiki | https://wiki.archlinux.org/title/Hyprland |
| DeepWiki | https://deepwiki.com/hyprwm/Hyprland/ |

### Release News

| Version | URL |
|---------|-----|
| v0.55 Announcement | https://hypr.land/news/update55/ |
| Lua Config Announcement | https://hypr.land/news/26_lua/ |

---

## Testing Changes

### Lua Config Syntax Check

Before reloading, validate Lua syntax:

```bash
# Check Lua syntax (config file)
luac -p ~/.config/hypr/hyprland.lua

# Check syntax of all required modules
luac -p ~/.config/hypr/keybinds.lua
```

If `luac` is not installed, install it (usually part of `lua` package):

```bash
# Debian/Ubuntu
sudo apt install lua5.4

# Arch
sudo pacman -S lua

# Fedora
sudo dnf install lua
```

### Validate Config Without Restarting

```bash
# Dry-run: check config validity without applying
hyprctl configcheck

# Returns errors/warnings without breaking current session
```

### Reload Config

```bash
# Soft reload (preserves state)
hyprctl reload

# Full reload (recommended for major changes, v0.55.3+)
hyprctl reload --full
```

### Verify Config Applied

```bash
# Check current config values
hyprctl getoption general.gaps_in
hyprctl getoption general.border_size

# List all windows
hyprctl clients

# List monitors
hyprctl monitors

# List workspaces
hyprctl workspaces
```

### Debug Logs

```bash
# View Hyprland logs (live)
journalctl --user -u hyprland -f

# Or check recent logs
journalctl --user -u hyprland --since "5 min ago"
```

### Test Keybinds

```bash
# List all active binds
hyprctl binds

# Test a dispatcher manually
hyprctl dispatch exec kitty
hyprctl dispatch workspace 2
hyprctl dispatch togglefloating
```

### Test Window Rules

```bash
# List active window rules
hyprctl rules

# Get current window info (run while focused on target)
hyprctl activewindow
```

### Plugin Testing

```bash
# List loaded plugins
hyprctl plugin list

# Load/unload plugin dynamically
hyprctl plugin load /path/to/plugin.so
hyprctl plugin unload /path/to/plugin.so

# Rebuild and reload plugin
make all && hyprctl plugin unload /path/to/plugin.so && hyprctl plugin load ./my-plugin.so
```

### LSP / Autocompletion Check

```bash
# Verify stubs are installed
ls /usr/share/hypr/stubs/

# Test Lua LSP in editor (VS Code example)
# Open .luarc.json, ensure workspace.library points to stubs
```

### Full Test Workflow

```bash
# 1. Syntax check
luac -p ~/.config/hypr/hyprland.lua

# 2. Validate config
hyprctl configcheck

# 3. Reload
hyprctl reload

# 4. Verify
hyprctl getoption general.gaps_in
hyprctl binds

# 5. Check logs for errors
journalctl --user -u hyprland --since "1 min ago"
```

### Emergency Recovery

If config breaks and Hyprland is unresponsive:

```bash
# From TTY (Ctrl+Alt+F2)
killall hyprland
# Or fix the config file
vim ~/.config/hypr/hyprland.lua
# Then restart
```

Emergency keybinds (default, work even on broken config):
- `SUPER+Q` — Open terminal
- `SUPER+R` — Run prompt
- `SUPER+M` — Exit Hyprland

---

## Notes for AI Agents

1. **Always use Lua config syntax** - The legacy `hyprlang` syntax is deprecated since v0.55
2. **The `hl` namespace is global** - Don't require/import it
3. **Config is Lua code** - Use `require()` for splitting files
4. **Error handling** - Lua errors are isolated per scope; major errors show an error bar
5. **Plugin API is C++ only** - Plugins must be compiled as shared objects
6. **hyprctl is the runtime interface** - Use for dynamic control and debugging
7. **Wiki is versioned** - Match wiki version to installed Hyprland version
8. **LSP stubs exist** - At `/usr/share/hypr/stubs/` for autocompletion setup
