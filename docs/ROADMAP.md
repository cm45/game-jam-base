# Incremental foundation roadmap

This repository is built one runnable milestone at a time. Each completed
milestone is validated and committed separately. The next milestone begins only
after the current one has been reviewed.

- [x] **1. Project foundation and developer experience** — Full asset pack,
  Git LFS, Godot 4.7.2 project settings, pixel-art defaults, shared UI theme,
  folder structure, Windows/Godot/VS Code setup, beginner exercises,
  architecture recipes, AI instructions, skills, and a pinned local Godot MCP
  integration with clone-ready configuration and usage guidance.
- [x] **2. App shell and core services** — Startup flow, scene switching,
  controls, audio/settings, pause menu, and save/reset infrastructure.
- [x] **3. Meta-progression framework** — Configurable currencies, persistent
  progress, upgrades, shop, and visual skill tree.
- [x] **4. Playable demo loop** — Top-down player movement and interactions,
  a freely walkable 2D home hub with NPC/station/run-entry interactions,
  pickups, collect-and-exit run, and rewards.
- [x] **5. Replaceable game integration** — Minimal starter scenes, the
  `RunContext`/`RunResult` contract, reusable components, and demo-removal
  proof.
- [x] **6. Release readiness** — Automated validation, fresh-clone check,
  save/reset tests, Windows export, and final jam checklist.
- [x] **Post-release foundation polish** — Desktop-sized shared UI, themed
  pause/settings screens, separate Gold shop and Insight skill-tree mechanics,
  an audible collision-ready starter camp, isolated save smoke tests, and a
  guide for replacing the starter or removing the demo.

## Review gates

1. Confirm the visual direction, asset organization, project layout, and
   onboarding material.
2. Test menus, settings, and scene flow.
3. Test progression configuration and assess the shop/tree workflow.
4. Play the complete loop and tune its pace.
5. Review adaptability, onboarding quality, and export readiness.
6. Confirm the remote `main` branch, fresh clone, Windows export, and weekend checklist.

## Defaults

- Windows desktop, Godot 4.7.2 Standard, typed GDScript, and keyboard/mouse.
- One local progression profile per game.
- No mid-run saves, rebinding, controller support, multiplayer, or cloud
  services in the first foundation version.
- Quests, inventory, combat, and customization are later extension recipes,
  not mandatory framework dependencies.

- [x] Camp review corrections: remove tour/lab menu entries, correct full
  house/tree atlas regions, and provide separate merchant/mentor windows.

- [x] Camp-first startup, normalized volume sliders, pause layering, working
  buffed upgrades, viewport-based tree fit, and frozen run-completion worlds.
