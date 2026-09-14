# Application flow

F5 starts directly in `game/starter_home.tscn`. The camp is the home hub.
The former foundation menu is removed. Escape opens settings, controls,
reset, Return to Camp, and Quit from the persistent AppShell.

AppShell uses CanvasLayer 100 so pause appears above all camp and run UI.
SceneRouter.return_home() abandons an unfinished run and returns to camp.
Use SceneRouter.change_to(path) for other transitions.

The preview and progression lab remain optional editor-only scenes (F6).
No application service depends on demo/.
