# Application services

This folder contains only application-wide behavior:

- `app_shell.gd` owns the pause/settings UI and menu sound.
- `scene_router.gd` changes scenes and defines the return-home route.

The main scene is `game/home.tscn`. The home calls GameDefinition to create
a gameplay context, then SceneRouter opens `game/gameplay.tscn`.
The former foundation menu, preview, and progression lab have been removed.
Use the real Merchant and Mentor to inspect progression.
