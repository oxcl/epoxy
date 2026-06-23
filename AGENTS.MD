## Project Overview

Before making any changes to this project, read `README.md` to understand what the project is about, its purpose, and overall structure.

## Hyprland

Every time you have to do something with Hyprland, you **must**:

1. Read the file `docs/hyprland.md` in the project root for context and guidelines.
2. Use web search to look up the latest Hyprland documentation, configuration syntax, or community best practices before implementing anything.
3. After any change to the Hyprland config, verify it with:
   ```bash
   Hyprland -c ~/.config/epoxy/hypr/hyprland.lua --verify-config
   ```
   This validates the config without starting Hyprland. Never skip this step.

## Foot Terminal

Every time you have to do something with Foot terminal, you **must**:

1. Read the file `docs/FOOTS.md` in the project root for context and guidelines.
2. Use web search to look up the latest Foot documentation, configuration syntax, or community best practices before implementing anything.
3. After any change to the Foot config, verify it with:
   ```bash
   foot --check-config
   ```
   This validates the config without starting Foot. Exit code 0 means valid, 230 means errors. Never skip this step.

4. For testing specific config files:
   ```bash
   foot --config=/path/to/foot.ini --check-config
   ```

5. For testing with overrides:
   ```bash
   foot --check-config -o "main.font=Fira Code:size=12"
   ```

## Git

**Never** commit or push to git unless explicitly told to do so for each individual change. Wait for the user to confirm before running `git commit` or `git push`.

## Symlinks

This project uses symlinks to integrate with the user's system:

- The `.bin` file is symlinked to the user's path so that `epoxy` can be run from anywhere as a command.
- The `config/` directory in this project is gitignored and symlinked to the user's config directory for epoxy, so the project treats the config file as the user's config directory. it is symlinked to ~/.config/epoxy
