# Setup notes

The root [README](../README.md) is the complete Windows setup checklist,
including Git LFS, Godot, VS Code, extensions, external-editor settings, and
AI/MCP setup. Follow it before the jam.

The repository already includes the Godot MCP editor add-on and client
configuration. Install Node.js 22 LTS or newer before cloning, then follow
[the Godot MCP guide](GODOT_MCP.md) after the project first opens in Godot.

The project uses Godot 4.7.2 Standard, the Compatibility renderer, a 640×360
base viewport, and nearest-neighbor filtering. Its initial window is 1920×1080,
which is an exact 3× scale of the internal pixel grid. A 2560×1440 display can
show the same grid at an exact 4× scale when the window is maximized or made
full-screen. Aspect preservation adds letterboxing instead of stretching the
art on other aspect ratios. Keep these choices when adding artwork that should
retain the Ninja Adventure pixel-art look.

The source pack lives under `assets/ninja_adventure/source/`. Its binary files
are LFS-managed, while its `LICENSE.txt` and `README.md` must remain intact.
Add project-specific art elsewhere under `assets/`; do not edit the vendored
pack in place.

Run the project with **F5** and choose **Play Starter Camp**. Optional developer
scenes `app/progression_lab.tscn` and `app/foundation_preview.tscn` can be
opened directly with **F6**; they have no player-menu entries.
