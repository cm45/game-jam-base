# Setup notes

The root [README](../README.md) is the complete Windows setup checklist,
including Git LFS, Godot, VS Code, extensions, external-editor settings, and
AI/MCP setup. Follow it before the jam.

The project uses Godot 4.7.2 Standard, the Compatibility renderer, a 640×360
base viewport, and nearest-neighbor filtering. Keep those choices when adding
artwork that should retain the Ninja Adventure pixel-art look.

The source pack lives under `assets/ninja_adventure/source/`. Its binary files
are LFS-managed, while its `LICENSE.txt` and `README.md` must remain intact.
Add project-specific art elsewhere under `assets/`; do not edit the vendored
pack in place.

Run the project with **F5** before beginning feature work. It opens the
Foundation Hub, which verifies the app shell, shared theme, settings menu, and
asset pack. `app/foundation_preview.tscn` is available from the hub as a second
scene for checking scene changes.
