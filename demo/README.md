# Playable demo

This folder is a complete, intentionally small example. It proves the loop
without becoming a dependency of `app/`, `features/`, `ui/`, or `game/`.

## Play it

1. Press **F5** and choose **Play the Demo Loop**.
2. Move through the grass-field camp with **WASD** or the arrow keys.
3. Press **E** beside the Caretaker, Scout, or Trader for dialogue; use the
   Path Shrine to open the shop and skill tree, or the Meadow Gate to begin a
   run.
4. In Sun Shard Meadow, collect all six yellow shards, walk to Meadow Exit, and
   press **E**.
5. Read the reward summary, return home, and spend Gold and Insight at the
   shrine. Start another run to see the new permanent stats in its HUD.

## What the demo proves

- `components/top_down_player.tscn` supplies movement while the run applies
  `Progression.get_effective_stat(&"run_speed", 72.0)`.
- `components/interaction_target.gd` lets the hub own what an NPC, shrine, or
  gate does when used.
- `components/resource_pickup.tscn` reports a pickup to the run without knowing
  anything about the player wallet.
- `demo_run.gd` awards its final Gold and Insight through `Progression`, then
  stores a small display-only last-run summary for `demo_home.gd`.
- **Lucky Satchel** changes the next run's reward multiplier. **Pathfinder**
  changes its move speed. **Trail Rations** changes the displayed starting
  health, making each configured effect easy to observe.

The `demo_last_run` save value is a demo-only presentation shortcut. Do not copy
it into a participant game. Milestone 5 replaces it with a documented,
replaceable run-result contract.
