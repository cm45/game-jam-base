# Project defaults and setup notes

The root [README](../README.md) is the complete initial setup guide. It covers
prerequisites, forking and cloning, the `upstream` remote, VS Code, Godot,
optional AI tools, MCP, and the checklist for later work sessions.

This page records project-specific defaults that are useful after setup.

## Rendering defaults

The project uses Godot 4.7.2 Standard, the Compatibility renderer, a 640×360
base viewport, and nearest-neighbor filtering. Its initial window is 1920×1080,
an exact 3× scale of the internal pixel grid. A 2560×1440 display can show the
same grid at an exact 4× scale when maximized or full-screen. Other aspect
ratios use letterboxing rather than stretching the art.

Keep these choices when adding artwork that should retain the Ninja Adventure
pixel-art look.

## Assets

The source pack lives under `assets/ninja_adventure/source/`. Its binary files
are managed by Git LFS. Keep its `LICENSE.txt` and `README.md` intact, and do
not edit the vendored source pack in place. Add project-specific art elsewhere
under `assets/`.

If an asset looks like a tiny text file beginning with a Git LFS pointer, run
this from the repository root:

```powershell
git lfs pull
```

## Entry points

Press **F5** to enter the home scene. Open `game/home.tscn` or
`game/gameplay.tscn` to edit the maps. Follow the
[game editing guide](../game/README.md) for the intended extension points.

For tools and editor configuration, return to the [README](../README.md). For
Git remotes, branches, syncing, and pull requests, use the
[development workflow](DEVELOPMENT_WORKFLOW.md).
