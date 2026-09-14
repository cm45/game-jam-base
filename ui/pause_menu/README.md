# Pause menu

`pause_menu.tscn` is instantiated once by the `AppShell` autoload. It pauses
the scene tree while its controls keep processing, so it works from any current
or future game scene.

Use `AppShell.open_menu()` to show the pause page, or pass `settings` or
`controls` to open a specific page. The menu owns presentation and emits menu
intent through the shared services:

- `AudioSettings` applies and saves Master, Music, and SFX values.
- The settings page includes a routed SFX preview so players can hear the
  current Master and SFX mix before leaving the menu.
- `SaveStore.reset_all()` clears persisted settings and the current progression
  wallet and upgrade levels.

The pause page offers Resume, Settings, Keybinds, and Quit. Resume closes the
menu in the current scene; returning from a run is handled by its gameplay flow.

Do not add genre-specific HUD or inventory controls here. Put shared menu
pages beside this scene and participant-specific controls in their own feature.
