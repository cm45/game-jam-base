# App shell and core services

Press **F5** to enter the camp. Escape opens settings, keybinds, reset, return
to camp, and quit; no separate foundation menu is needed.

## What every participant can use

| Need | Use |
| --- | --- |
| Change scenes | `SceneRouter.change_to("res://path/to/scene.tscn")` |
| Return to the current startup scene | `SceneRouter.return_home()` |
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

1. Press **F5** and confirm the camp opens.
2. Start a run at the Scout, then return through the pause menu.
3. Press Escape in either scene. Check resume, keybinds, and return-to-hub.
4. Open settings, move each volume slider, close and reopen the menu, and
   confirm the values remain.
5. Choose **Reset Save and Settings**, confirm it, then check sliders return to
   the defaults. Restart the project to check persistence.
6. Visit Merchant and Mentor after a reset to confirm currencies and upgrade
   levels are also cleared.

Headless validation catches parsing and loading faults. A person must perform
the route above to verify focus, menu presentation, audio audibility, and quit
behavior.
