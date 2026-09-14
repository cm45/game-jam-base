# UI

The shared visual language lives here. Use `theme/game_jam_theme.tres` on UI
roots unless a screen deliberately needs its own theme.

`theme/hud_panel.tres` is a compact wood-panel override for in-world HUD
chips. Use it when persistent information should stay out of the playable area.

The main theme keeps the supplied pixel font at its intended 16-pixel size and
adds word spacing through a `FontVariation`. Do not reduce that default just to
make a layout fit; use a compact panel or simpler HUD content instead.

`pause_menu/` contains the shared pause, settings, keybind, reset, and quit
interface. It uses the supplied wood UI theme and is created by the persistent
`AppShell` autoload, not by individual game scenes.

The progression shop and tree live under `features/progression/ui/` because
they belong to that feature's data and purchasing rules. The application hosts
the shared layout under automated checks; the home opens the Shop from the
Merchant and the Skill Tree from the Mentor.
