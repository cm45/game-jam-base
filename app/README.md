# App shell

This folder owns startup, persistent UI, and scene changes. `foundation_hub.tscn`
is the current main scene. It is deliberately a foundation landing page rather
than a home scene, so each participant can add their own home and run in a later
milestone.

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
