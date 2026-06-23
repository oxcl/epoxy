# Epoxy

A personal AI agent-driven development environment. Not an IDE, not a editor — a composed workspace where autonomous AI agents operate alongside humans through accessible IPC.

## Philosophy

Most AI coding tools try to build everything from scratch: custom terminals, custom editors, custom everything. Epoxy takes the opposite approach.

**Epoxy is glue.**

It composes existing, battle-tested applications into a single cohesive environment:

| Component | Role |
|-----------|------|
| **SomeWM** | Layout engine and window management (nested inside your existing desktop) |
| **Foot** | Terminal emulator |
| **Rofi** | UI layer — command palette, fuzzy finder, selection menus |
| **Nix** | Build system — packages all dependencies into one reproducible unit |
| **Pi** | Coding Agent |
| **CloakBrowser** | Integrated Browser |
| **Cage** | Integrated Compositor |
| **Shell scripts** | Orchestration — the actual glue connecting everything |

Instead of writing a terminal, we use a terminal. Instead of writing a window manager, we use a window manager. Instead of building a UI framework, we use rofi.

The result is something like a "claude desktop" or "codex-like" environment, but built by composing rather than creating from nothing.

## How It Works

```
┌─────────────────────────────────────────┐
│           Your Desktop (KDE, etc.)      │
│  ┌───────────────────────────────────┐  │
│  │     Epoxy (SomeWM nested)         │
│  │  ┌──────────┐  ┌──────────┐       │  │
│  │  │   Foot   │  │   Foot   │  ...  │  │
│  │  │ (pane)   │  │ (pane)   │       │  │
│  │  └──────────┘  └──────────┘       │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │   Rofi (command palette)    │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

1. Epoxy launches as a regular application in your existing desktop session
2. It spawns a nested SomeWM instance with its own Lua config
3. SomeWM manages the layout (panes, splits, workspaces)
4. Foot terminals run inside the SomeWM instance
5. Rofi provides the UI layer for commands and selections
6. Pi coding agent runs inside the foot terminal

## AI Agent Integration

The key differentiator: **everything is accessible via IPC**.

SomeWM, rofi CLI, foot's controls — all of these are the same interfaces available to AI agents. An agent can:

- Open new terminal panes
- Create or switch workspaces
- Modify window layouts
- Execute commands
- Interact with the command palette

The environment is designed so that the AI doesn't need special APIs or wrappers. It uses the same tools a human would use, just programmatically.

## Configuration

Epoxy expects its config at `~/.config/epoxy

## For AI Agents

If you're an AI agent working on this codebase:

1. Read `AGENTS.MD` for project guidelines
2. Useful documentation lives in `docs/`
3. source code of some dependencies are available in `refs/` they are not part of the codebase just provided as reference 

## Status

Personal project. Not intended for public use or distribution.
