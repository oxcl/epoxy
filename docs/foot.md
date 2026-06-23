# Foot Terminal Guide for AI Agents

> **Version**: v1.26.1 (June 2026) | **Config System**: INI | **Type**: Wayland-native terminal

## What is Foot?

Foot is a fast, lightweight, and minimalistic terminal emulator written in C, designed specifically for Wayland from the ground up. Unlike many older terminal emulators that gained Wayland support through XWayland compatibility layers, Foot is Wayland-native.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Configuration System](#configuration-system)
3. [Key Features](#key-features)
4. [CLI Commands](#cli-commands)
5. [Configuration Validation](#configuration-validation)
6. [Common Tasks](#common-tasks)
7. [Known Limitations](#known-limitations)
8. [Documentation Links](#documentation-links)

---

## Architecture Overview

Foot runs as a Wayland terminal emulator with optional server/daemon mode.

### Key Architectural Components

- **Foot** (`foot`) - The main terminal binary
- **Footclient** (`footclient`) - Client for server mode
- **Server Mode** - Single process hosts multiple windows (reduced memory, shared fonts/glyph cache)
- **INI Configuration** - Standard INI format with section-based key/value pairs

### Key Directories

| Path | Purpose |
|------|---------|
| `~/.config/foot/foot.ini` | User configuration file |
| `/etc/xdg/foot/foot.ini` | System-wide configuration |
| `/usr/share/foot/themes/` | Bundled color themes |

---

## Configuration System

### File Format

Standard INI format with section-based key/value pairs:
- Keys and values separated by `=`
- Empty values not supported; use `KEY=""` for empty strings
- Sections denoted by `[section-name]`

### Configuration Sections

| Section | Purpose |
|---------|---------|
| `[main]` | Core settings (shell, font, window size, etc.) |
| `[environment]` | Environment variables |
| `[security]` | OSC52 clipboard security |
| `[bell]` | Bell/notification settings |
| `[desktop-notifications]` | Notification settings |
| `[scrollback]` | Scrollback buffer size and behavior |
| `[url]` | URL detection and launch settings |
| `[regex]` | Custom regex patterns |
| `[cursor]` | Cursor style and color |
| `[mouse]` | Mouse behavior |
| `[touch]` | Touch input settings |
| `[colors-dark]` | Dark color theme |
| `[colors-light]` | Light color theme |
| `[csd]` | Client-side decoration settings |
| `[key-bindings]` | Keyboard shortcuts |
| `[search-bindings]` | Scrollback search shortcuts |
| `[url-bindings]` | URL mode shortcuts |
| `[text-bindings]` | Text input bindings |
| `[mouse-bindings]` | Mouse button bindings |

### Importing Configuration Files

```ini
[main]
include=/path/to/shared/config.ini
include=~/path/to/another/config.ini
```

- Multiple imports allowed
- Nested imports supported
- Must be absolute paths or start with `~/`

### Example Configuration

```ini
[main]
term=xterm-256color
font=JetBrains Mono:size=11
dpi-aware=auto
login-shell=no

[mouse]
hide-when-typing=yes

[scrollback]
lines=10000

[cursor]
style=block

[key-bindings]
clipboard-copy=Control+Shift+C XF86Copy
clipboard-paste=Control+Shift+V XF86Paste
font-increase=Control+Plus
font-decrease=Control+Minus
font-reset=Control+0
```

---

## Key Features

### Performance
- CPU-side software rendering (no GPU acceleration)
- Near-instant startup
- ~21 MB idle memory usage
- Optimized for interactive use

### Server/Daemon Mode
- Single process hosts multiple windows
- Shared fonts and glyph cache across windows
- Reduced memory footprint
- Launch with `foot --server` or `foot -s`

### Theming
- Supports dark and light color themes
- Runtime switching via key bindings or signals
- 100+ bundled themes
- Theme inclusion: `include=/usr/share/foot/themes/dracula`

### Font Configuration
- FontConfig syntax with colon-separated options
- Configurable font fallback chain
- On-the-fly font resize (Ctrl++/Ctrl+-/Ctrl+0)
- DPI-aware font sizing

### Shell Integration
- OSC 7: CWD reporting
- OSC 133: Shell integration (prompt detection)
- Compatible with bash, zsh, fish

---

## CLI Commands

### Foot (Main Command)

| Option | Description |
|--------|-------------|
| `-c, --config=PATH` | Path to configuration file |
| `-C, --check-config` | Verify configuration and exit |
| `-o, --override=[SECTION.]KEY=VALUE` | Override config option |
| `-f, --font=FONT` | Comma-separated font list |
| `-w, --window-size-pixels=WxH` | Initial window size in pixels |
| `-W, --window-size-chars=CxR` | Initial window size in characters |
| `-t, --term=TERM` | Set TERM environment variable |
| `-T, --title=TITLE` | Initial window title |
| `-a, --app-id=ID` | Set Wayland app-id property |
| `-s, --server[=PATH\|FD]` | Run in server/daemon mode |
| `-m, --maximized` | Start maximized |
| `-F, --fullscreen` | Start fullscreen |
| `-L, --login-shell` | Start as login shell |
| `-H, --hold` | Keep terminal open after command exits |
| `-p, --print-pid=FILE\|FD` | Print PID to file |
| `-d, --log-level={info,warning,error,none}` | Log level |
| `-v, --version` | Show version |

### Footclient (Server Mode Client)

| Option | Description |
|--------|-------------|
| `-t, --term=TERM` | Set TERM variable |
| `-T, --title=TITLE` | Window title |
| `-a, --app-id=ID` | Wayland app-id |
| `-w, --window-size-pixels=WxH` | Initial size (pixels) |
| `-W, --window-size-chars=CxR` | Initial size (chars) |
| `-m, --maximized` | Start maximized |
| `-F, --fullscreen` | Start fullscreen |
| `-L, --login-shell` | Login shell |
| `-D, --working-directory=DIR` | Set working directory |
| `-s, --server-socket=PATH` | Custom socket path |
| `-H, --hold` | Keep terminal open |
| `-N, --no-wait` | Detach client immediately |
| `-o, --override=[SECTION.]KEY=VALUE` | Override config |
| `-E, --client-environment` | Use client's environment |
| `-d, --log-level={info,warning,error,none}` | Log level |
| `-v, --version` | Show version |

---

## Configuration Validation

### Built-in Validation Command

Foot includes a built-in configuration checker:

```bash
foot --check-config
# or
foot -C
```

**Exit codes:**
- `0`: Configuration is valid
- `230`: Configuration has errors

### Testing Specific Config Files

```bash
# Test with specific config file
foot --config=/path/to/foot.ini --check-config

# Test with overrides
foot --check-config -o "main.font=Fira Code:size=12"
```

### What the Validator Checks

The `--check-config` flag validates:
- Syntax correctness
- Valid option names and values
- Color format validation
- Font availability
- Section structure

**Note**: There is no separate `foot-config-check` tool; the `--check-config` flag is the primary validation mechanism.

---

## Common Tasks

### Launch in Server Mode

```bash
# Start server
foot --server

# Connect client
footclient
```

### Test Configuration

```bash
# Validate configuration
foot --check-config

# Test with specific config
foot --config=~/.config/foot/foot.ini --check-config
```

### Override Configuration

```bash
# Override font
foot -o "main.font=JetBrains Mono:size=14"

# Override multiple options
foot -o "main.font=JetBrains Mono:size=14" -o "scrollback.lines=5000"
```

### Switch Color Theme (Runtime)

```bash
# Via signals
killall -SIGUSR1 foot  # Switch to dark theme
killall -SIGUSR2 foot  # Switch to light theme

# Via key binding (configurable)
# Default: Ctrl+Shift+T for toggle
```

### Debug Issues

```bash
# Check version
foot --version

# Run with verbose logging
foot --log-level=info

# Check terminfo
infocmp foot
infocmp foot-direct
```

### Shell Integration Setup

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# OSC 7 - Report CWD
if [ -n "$FOOT_PID" ]; then
    printf '\033]7;file://%s%s\a' "$(hostname)" "$PWD"
fi
```

### Install Terminfo

```bash
# For remote systems without foot terminfo
infocmp -x foot | ssh remote-host 'infocmp -x - > /tmp/foot.ti && tic -x /tmp/foot.ti'

# Or install to user directory
infocmp foot > /tmp/foot.ti
tic -o ~/.terminfo /tmp/foot.ti
```

---

## Known Limitations

### Feature Limitations
- **No tabs**: Single-window application (use server mode + tmux for multiplexing)
- **No split windows**: Not a terminal multiplexer
- **No profiles**: Single configuration
- **No Kitty/iTerm2 image protocols**: Only Sixel supported
- **No GPU acceleration**: CPU rendering only (by design)
- **No config hot-reload**: Must restart foot or use OSC sequences for color changes

### Server Mode Caveats
- All windows' I/O multiplexed in single thread
- Busy windows can slow down others
- Server crash kills all terminal windows
- Slightly worse performance under heavy multi-window load

### Terminfo Issues
- Some applications may not recognize `foot` terminfo
- Remote systems may not have foot terminfo installed
- Workaround: Use `xterm-256color` or install terminfo in `~/.terminfo/f/`
- Emacs requires `foot-direct` for 24-bit color

### DPI/Scaling Gotchas
- Fractional scaling: Foot > 1.15 defaults to compositor scaling factor
- Moving between monitors with different DPIs may cause font size changes
- `dpi-aware=yes` ensures consistent physical size across monitors

### OSC52 Security

```ini
[security]
osc52=clipboard-only  # or "yes" or "no"
```

### Configuration Not Reloaded
- Must restart foot to apply config changes
- Use OSC sequences or signals for runtime color changes
- Server mode: Kill and restart server for config changes

---

## Documentation Links

### Official

| Resource | URL |
|----------|-----|
| **Source Repository** | https://codeberg.org/dnkl/foot |
| **Wiki** | https://codeberg.org/dnkl/foot/wiki |
| **Man Page (foot)** | `man foot` or https://man.archlinux.org/man/foot.1.en |
| **Man Page (foot.ini)** | `man foot.ini` or https://man.archlinux.org/man/foot.ini.5.en |
| **Man Page (footclient)** | `man footclient` or https://man.archlinux.org/man/footclient.1.en |
| **Man Page (foot-ctlseqs)** | `man foot-ctlseqs` or https://man.archlinux.org/man/foot-ctlseqs.7.en |
| **Bug Reports** | https://codeberg.org/dnkl/foot/issues |
| **Changelog** | https://codeberg.org/dnkl/foot/raw/branch/master/CHANGELOG.md |

### Distribution-Specific

| Distribution | URL |
|--------------|-----|
| **Arch Wiki** | https://wiki.archlinux.org/title/Foot |
| **Debian Manpages** | https://manpages.debian.org/trixie/foot/foot.1.en.html |
| **Ubuntu Manpages** | https://manpages.ubuntu.com/manpages/jammy/man1/foot.1.html |

### NixOS/Nix

| Resource | URL |
|----------|-----|
| **Home Manager Module** | https://github.com/nix-community/home-manager/blob/master/modules/programs/foot.nix |
| **Nixpkgs Package** | https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/fo/foot/package.nix |
| **MyNixOS Options** | https://mynixos.com/options/programs.foot |

### Community

| Resource | URL |
|----------|-----|
| **Theme Preview Tool** | https://github.com/trinitronx/preview-foot-themes |
| **Dracula Theme** | https://github.com/dracula/foot |
| **Performance Wiki** | https://codeberg.org/dnkl/foot/wiki/Performance |

---

## Testing Changes

### Configuration Validation Workflow

```bash
# 1. Validate syntax
foot --check-config

# 2. Test with specific config
foot --config=~/.config/foot/foot.ini --check-config

# 3. Test with overrides
foot --check-config -o "main.font=JetBrains Mono:size=14"

# 4. Check exit code
echo $?  # 0 = OK, 230 = error
```

### Verify Configuration Applied

```bash
# Check current font (run in foot terminal)
echo $FONT

# Check terminfo
infocmp foot

# Check version
foot --version
```

### Debug Logs

```bash
# Run with verbose logging
foot --log-level=info

# Check systemd logs (if using systemd user service)
journalctl --user -u foot-server -f
```

### Test Keybinds

```bash
# List all active binds (in terminal)
# Check config file for key-bindings section
cat ~/.config/foot/foot.ini | grep -A 20 "\[key-bindings\]"
```

### Emergency Recovery

If foot configuration breaks:

```bash
# From another terminal or TTY
# Fix the config file
vim ~/.config/foot/foot.ini

# Or use default config
foot --config=/dev/null

# Or validate and fix
foot --check-config  # Shows errors
```

---

## Notes for AI Agents

1. **INI format is simple** - Use standard INI syntax with `[section]` headers
2. **No hot-reload** - Must restart foot for config changes
3. **Server mode is optional** - Useful for shared memory, but has trade-offs
4. **Use `--check-config`** - Always validate before launching
5. **Font syntax is FontConfig** - Use colon-separated options
6. **Themes are INI files** - Can be included with `include=`
7. **Terminfo matters** - Some apps need `foot` terminfo for full features
8. **DPI-aware by default** - Handles multi-monitor setups well
