## Project Overview

Before making any changes to this project, read `README.md` to understand what the project is about, its purpose, and overall structure.

## Hyprland

Every time an you have to do something with Hyprland, you **must**:

1. Read the file `docs/hyprland.md` in the project root for context and guidelines.
2. Use web search to look up the latest Hyprland documentation, configuration syntax, or community best practices before implementing anything.

## Symlinks

This project uses symlinks to integrate with the user's system:

- The `.bin` file is symlinked to the user's path so that `epoxy` can be run from anywhere as a command.
- The `config/` directory in this project is gitignored and symlinked to the user's config directory for epoxy, so the project treats the config file as the user's config directory. it is symlinked to ~/.config/epoxy
