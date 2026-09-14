# Playable demo loop

Milestone 4 provides a complete, short example of the intended jam rhythm:
**walkable home → run → permanent rewards → home upgrades → changed next run**.
It is located entirely in `demo/` so it can teach the foundation without
constraining a participant's genre.

## Manual review route

1. Open `demo/demo_home.tscn` and press **F6** to run the optional demo.
2. Walk around the grass-field camp. Confirm the player can approach the
   Caretaker, Scout, Trader, Path Shrine, and Meadow Gate from the world
   itself.
3. Press **E** near each resident and read the message. At the shrine, confirm
   the shop opens without its `+25 Gold` or `+1 Insight` sandbox controls.
4. Use the Meadow Gate. Collect the six yellow Sun Shards, then walk to Meadow
   Exit and press **E**.
5. Confirm the reward screen shows Gold, Insight, and the reward multiplier.
   Return home and confirm the wallet changed.
6. Buy **Lucky Satchel** with Gold when affordable, complete another run, and
   check that its Gold reward is multiplied. Earn Insight, open **Skill Tree**,
   and unlock **Pathfinder**; the next run HUD should show the higher speed.
7. Press Escape from either scene and confirm the shared pause menu still works.

Headless checks catch scene and script errors. This route needs a person because
movement, interaction range, visual composition, focus, and sound are player
experience checks.

## Ownership

`demo_home.gd` owns hub presentation and responds to its three interaction
targets. `demo_run.gd` owns the shard counter, exit requirement, reward
calculation, and result screen. The components only report local events;
neither component writes progression or changes scenes.

The run grants its permanent reward only when its exit is used after all six
shards are collected. It calls `Progression.grant_currency()` for those changes,
so the existing save, wallet, shop, and tree agree. It also saves a small
`demo_last_run` dictionary solely so the home can show a last-expedition line.
That direct demo handoff is deliberately confined to this teaching example.
Milestone 5 provides the general `RunContext` and `RunResult` contract for
participant scenes under `game/`; use that route for new work.

## Change it safely

- To alter the loop length, change `REQUIRED_SHARDS`, pickup placements, and
  `BASE_GOLD_REWARD` together in `demo/demo_run.gd`.
- To use a different persistent resource, define it in the progression catalog
  first, then award it only from the completed-run method.
- To add a hub station, duplicate an `InteractionTarget` in `demo_home.tscn`,
  connect its `activated` signal in `demo_home.gd`, and let that scene decide
  the resulting UI or route.
- To prototype a different run genre, keep the player, components, and
  progression service if useful, but replace the demo scene itself. Do not make
  `app/` depend on the replacement.
