# Game starter

This folder contains the minimal home and run scenes a participant adapts:

- `starter_home.tscn` is a freely walkable 2D hub with an in-world upgrade
  station and run entrance.
- `starter_run.tscn` is a three-pickup collect-and-exit example. Replace its
  rule with any genre while keeping its result handoff.
- `starter_game.gd` owns only the starter scene paths, stable run ID, and the
  permanent effects passed into a new run.
- `starter_world_surface.gd` is a draw-only grass clearing. Replace it with a
  TileMap, procedural world, or custom scene without changing the contract.

The home is responsible for creating a `RunContext`, storing it with
`RunSession.begin_run()`, and routing to the run. The run reads that context,
owns its own completion rule, creates a `RunResult`, and calls
`RunSession.complete_run()` before returning home. Read
[the contract](../docs/RUN_CONTRACT.md) before renaming the starter files.

The demo remains separate and can be studied or removed safely. Nothing in
`game/`, `app/`, `features/`, or `ui/` imports a demo scene or script.

## Manual review route

1. Press **F5** and choose **Open Starter Game**.
2. Walk to **START RUN**, press **E**, and collect the three yellow tokens.
3. Use **RETURN**, then select **Claim and Return Home** on the result panel.
4. Confirm Gold and Insight increased in the home HUD and the last-run message
   appears. Use **UPGRADES** to confirm the feature UI is still an in-world
   overlay.
