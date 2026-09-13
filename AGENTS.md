# Game Jam Foundation instructions

This repository is a Godot 4.7.2 GDScript foundation for a weekend game jam.
Keep every completed milestone runnable and make only the milestone currently
authorized by the project owner.

## Working in this repository

- Read the root README.md and the relevant file in docs/ before changing a
  system. Explain an unfamiliar part before changing it when a beginner would
  benefit.
- Place reusable behavior in features/, optional composable nodes in
  components/, application-wide flow in app/, shared presentation in ui/,
  participant-specific scenes in game/, and demonstrations in demo/.
- Keep source assets in assets/ninja_adventure/source/ unchanged. They are
  vendored third-party material and Git LFS manages their binary files.
- Do not commit .godot/, generated *.import files, exports, local saves,
  credentials, or editor-specific machine paths.
- Use typed GDScript where a type is clear. Prefer small scripts, named signals,
  early returns, and comments that explain decisions rather than restating code.
- Preserve the 640×360 viewport, nearest-neighbor art treatment, and the shared
  theme unless a task explicitly changes the visual direction.

## Completing a change

- Update the closest README or document when behavior, setup, or extension
  points change.
- Run the smallest meaningful check. For project-wide changes, run Godot
  headlessly with --path . --editor --quit and run the main scene.
- Inspect git diff --check before committing. Keep one commit per approved
  milestone on a framework/ branch.

## Code review rules

- Flag changes that edit the Ninja Adventure source pack, rely on a generated
  .import file, hard-code a developer's local path, or make a later milestone
  necessary for the current scene to start.
