# App shell

This folder owns startup, persistent UI, and scene changes. `foundation_hub.tscn`
is the current main scene. Its **Play the Demo Loop** button enters the
demonstration's walkable home scene; it remains a landing page rather than a
participant's own home scene.

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
project. It remains useful for inspecting wallet persistence, purchasing,
prerequisites, effects, shop cards, and the skill tree in isolation. The demo
home opens the same panel from its in-world Path Shrine without sandbox tools.
