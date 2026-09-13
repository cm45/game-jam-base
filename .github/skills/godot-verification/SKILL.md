---
name: godot-verification
description: Verify a Game Jam Foundation change before it is committed. Use after editing Godot scenes, scripts, project configuration, or setup files.
---

# Godot verification workflow

Choose checks that match the change and report the commands and outcomes.

1. Check the changed scenes and resource paths for spelling and ownership.
2. Start Godot headlessly with the project path and editor quit flags to catch
   import and parse failures.
3. Start the main scene headlessly when startup flow or project configuration
   changed.
4. Run any focused test that covers changed behavior.
5. Inspect Git diff whitespace and confirm generated .godot and .import files
   are not staged.
6. If vendored assets changed unexpectedly, stop and inspect the change rather
   than accepting it.

Do not claim visual, input, or audio behavior passed from a headless check.
State when a person needs to test the scene in the Godot editor.
