# App shell and core services

Milestone 2 adds a runnable app shell without choosing a genre. Press **F5** to
open the Foundation Hub. Its preview button changes to the existing preview
scene; the preview's back button returns through the shared router.

## What every participant can use

| Need | Use |
| --- | --- |
| Change scenes | `SceneRouter.change_to("res://path/to/scene.tscn")` |
| Return to the current startup scene | `SceneRouter.return_to_foundation_hub()` |
| Open the pause menu | `AppShell.open_menu()` |
| Open settings or controls directly | `AppShell.open_menu(&"settings")` or `AppShell.open_menu(&"controls")` |
| Read a starter input binding | `InputActions.get_binding_text(InputActions.INTERACT)` |
| Read or set a shared volume | `AudioSettings.get_volume(...)` / `set_volume(...)` |
| Persist a permanent value later | `SaveStore.get_progress(...)` / `set_progress(...)` |

The `AppShell` pause menu is always available through the `pause` action
(Escape by default). It pauses the current scene tree while the menu continues
to process. The pause menu supplies resume, settings, keybinds, reset, return
to hub, and quit controls.

## Startup order

Godot creates the autoloads in the order shown in `project.godot`: input,
save, audio, routing, then the shell. The main scene can rely on those services
being available. New game scenes should use them, not create duplicate global
managers.

## Manual review route

1. Press **F5** and confirm the Foundation Hub opens.
2. Choose **Open Foundation Preview**, then use **Back to Foundation Hub**.
3. Press Escape in either scene. Check resume, keybinds, and return-to-hub.
4. Open settings, move each volume slider, close and reopen the menu, and
   confirm the values remain.
5. Choose **Reset Save and Settings**, confirm it, then check sliders return to
   the defaults. Restart the project to check persistence.

Headless validation catches parsing and loading faults. A person must perform
the route above to verify focus, menu presentation, audio audibility, and quit
behavior.
