## Project Overview

Before making any changes to this project, read `README.md` to understand what the project is about, its purpose, and overall structure.


source code of some dependencies are available in `refs/` they are not part of the codebase just provided as reference 
documentation of some dependencies are available in `docs/` they are not part of the codebase just provided as reference 

## SomeWM

Every time you have to do something with SomeWM, you **must**:

1. Read the file `docs/somewm-docs` in the project root for context and guidelines.
2. Use web search to look up the latest SomeWM documentation, configuration syntax, or community best practices before implementing anything.
3. After any change to the SomeWM config, verify it with:
   ```bash
   somewm --check-config .config/epoxy/somewm/rc.lua
   ```
   This validates the config without starting someWM. Never skip this step.

## Foot Terminal

Every time you have to do something with Foot terminal, you **must**:

1. Read the file `docs/foot-docs` in the project root for context and guidelines.
2. Use web search to look up the latest Foot documentation, configuration syntax, or community best practices before implementing anything.
3. After any change to the Foot config, verify it with:
   ```bash
   foot --config=/path/to/foot.ini --check-config
   ```
   This validates the config without starting Foot. Exit code 0 means valid, 230 means errors. Never skip this step.

## Git

**Never** commit or push to git unless explicitly told to do so for each individual change. Wait for the user to confirm before running `git commit` or `git push`.

## Symlinks

This project uses symlinks to integrate with the user's system:

- The `.bin` file is symlinked to the user's path so that `epoxy` can be run from anywhere as a command.
- The `config/` directory in this project is gitignored and symlinked to the user's config directory for epoxy, so the project treats the config file as the user's config directory. it is symlinked to ~/.config/epoxy


## Theme
the project uses the flexoki theme. the themes are accessible in refs/flexoki you have to adapt the colors from the reference for the specific thing you are doing