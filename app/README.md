# App shell

This folder owns startup, persistent UI, and scene changes. `foundation_hub.tscn`
is the current main scene. Its **Play Starter Camp** button enters the
participant-owned walkable home in `game/`; it remains a landing page rather
than a home scene itself.

The autoloads in `project.godot` provide the shell:

- `AppShell` keeps the pause menu alive across scene changes.
- `SceneRouter` changes scenes through one documented API.
- `InputActions` registers the shared keyboard action names.
- `SaveStore` and `AudioSettings` are reusable feature services used by the
  pause menu.

Use `SceneRouter.change_to("res://path/to/scene.tscn")` instead of calling a
scene change from a menu or game node. `foundation_preview.tscn` remains as a
second scene for testing that route before game scenes exist. See
[`docs/APP_SHELL.md`](../docs/APP_SHELL.md) for the public API and review steps.

`progression_lab.tscn` hosts the feature-owned progression interface for this
project. It remains useful for inspecting wallet persistence, Gold shop
purchases, Insight prerequisites, effects, shop cards, and the skill tree in
isolation. The starter camp opens the same panel from its Merchant and Mentor
stations without sandbox tools.

`app/` deliberately has no `demo/` scene reference. The demo remains runnable
with **F6**, while the main app starts the independent starter game.

The player menu contains only Play Starter Camp, Settings, Keybinds, and Quit.
The foundation tour and progression lab are not exposed in the menu. Optional
preview and lab scenes can still be opened directly in the editor with F6.
The camp uses separate shop-only and skill-only window scenes.
