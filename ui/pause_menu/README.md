# Pause menu

`pause_menu.tscn` is instantiated once by the `AppShell` autoload. It pauses
the scene tree while its controls keep processing, so it works from any current
or future game scene.

Use `AppShell.open_menu()` to show the pause page, or pass `settings` or
`controls` to open a specific page. The menu owns presentation and emits menu
intent through the shared services:

- `AudioSettings` applies and saves Master, Music, and SFX values.
- `SaveStore.reset_all()` clears persisted settings and future progression data.
- `SceneRouter.return_to_foundation_hub()` returns from a run without the menu
  knowing anything about that run's implementation.

Do not add genre-specific HUD or inventory controls here. Put shared menu
pages beside this scene and participant-specific controls in their own feature.
