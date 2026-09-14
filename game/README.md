# Game starter

This folder contains the minimal home and run scenes a participant adapts:

- `starter_home.tscn` is a freely walkable 2D camp with a Merchant Gold shop,
  Mentor Insight skill tree, Scout run entrance, solid scenery, and Music-bus
  ambience.
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
`game/`, `app/`, `features/`, or `ui/` imports a demo scene or script. Read
[the replacement guide](../docs/REPLACE_STARTER.md) before changing direction
or removing the examples.

## Manual review route

1. Press **F5** to start directly in camp.
2. Walk to the Merchant or Mentor and press **E** to compare the shop and
   skill-tree systems. Walk into scenery to test its collisions.
3. Walk to the Scout, press **E**, and collect the three yellow tokens.
4. Use **RETURN**, then select **Claim and Return Home** on the result panel.
5. Confirm Gold and Insight increased in the home HUD and the last-run message
   appears. Revisit the Merchant or Mentor to confirm the feature UI remains an
   in-world overlay.

Scenery atlas regions: the round tree uses (0, 0, 32, 32) from TilesetNature;
the complete first house uses (0, 0, 64, 48) from TilesetHouse. Include only
the intended sprite, not pieces of adjacent atlas rows. Merchant and Mentor
open independent, locked shop and skill windows without cross-navigation.

F5 starts in camp directly. Escape opens settings, controls, quit, and Return
to Camp above station windows. Run completion freezes the local world while
the reward interface stays interactive; closing pause does not unfreeze it.
