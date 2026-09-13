# Incremental foundation roadmap

This repository is built one runnable milestone at a time. Each completed
milestone is validated and committed separately. The next milestone begins only
after the current one has been reviewed.

- [x] **1. Project foundation and developer experience** — Full asset pack,
  Git LFS, Godot 4.7.2 project settings, pixel-art defaults, shared UI theme,
  folder structure, Windows/Godot/VS Code setup, beginner exercises,
  architecture recipes, AI instructions, skills, and MCP guidance.
- [ ] **2. App shell and core services** — Startup flow, scene switching,
  controls, audio/settings, pause menu, and save/reset infrastructure.
- [ ] **3. Meta-progression framework** — Configurable currencies, persistent
  progress, upgrades, shop, and visual skill tree.
- [ ] **4. Playable demo loop** — Movement, interactions, pickups,
  collect-and-exit run, rewards, and home scene.
- [ ] **5. Replaceable game integration** — Minimal starter scenes, the
  `RunContext`/`RunResult` contract, reusable components, and demo-removal
  proof.
- [ ] **6. Release readiness** — Automated validation, fresh-clone check,
  save/reset tests, Windows export, and final jam checklist.

## Review gates

1. Confirm the visual direction, asset organization, project layout, and
   onboarding material.
2. Test menus, settings, and scene flow.
3. Test progression configuration and assess the shop/tree workflow.
4. Play the complete loop and tune its pace.
5. Review adaptability, onboarding quality, and export readiness.

## Defaults

- Windows desktop, Godot 4.7.2 Standard, typed GDScript, and keyboard/mouse.
- One local progression profile per game.
- No mid-run saves, rebinding, controller support, multiplayer, or cloud
  services in the first foundation version.
- Quests, inventory, combat, and customization are later extension recipes,
  not mandatory framework dependencies.
