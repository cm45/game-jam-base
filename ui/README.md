# UI

The shared visual language lives here. Use `theme/game_jam_theme.tres` on UI
roots unless a screen deliberately needs its own theme.

`pause_menu/` contains the shared pause, settings, keybind, reset, and quit
interface. It uses the supplied wood UI theme and is created by the persistent
`AppShell` autoload, not by individual game scenes.

The progression shop and tree live under `features/progression/ui/` because
they belong to that feature's data and purchasing rules. The application hosts
them in a standalone lab until a later home scene takes ownership.
