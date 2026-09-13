# Extension recipes

These are small decision guides for later milestones. Follow the relevant
milestone contract when it arrives; the recipes describe where the work belongs
without committing the project to a genre.

## Add a shared input action

Add a named constant and a default binding in `features/input/input_actions.gd`.
Use that constant in scripts, such as `InputActions.INTERACT`, rather than
repeating a string. Add the action to the pause menu's keybind page if a player
needs to discover it. This milestone deliberately has no rebinding UI; preserve
existing Input Map events so that system can arrive later.

## Play music or a sound effect

Set an `AudioStreamPlayer` node's **Bus** to `Music` for background music or
`SFX` for effects. Let `AudioSettings` control its volume through the shared bus
rather than giving every player its own volume slider. If a game needs another
mix group, add it to `features/audio/default_bus_layout.tres` and document its
purpose beside the audio service.

## Save a small permanent value

Use `SaveStore.set_progress(&"stable_id", value)` for small game-owned
meta-progression and `SaveStore.get_progress(&"stable_id", fallback)` to read
it. Choose stable, snake_case identifiers. Do not save during a run from an
arbitrary node; return permanent currency through `RunResult` so it is committed
at completion by `RunSession`.

## Add a new permanent resource

1. Add a `CurrencyDefinition` to the progression catalog with a stable ID,
   display name, description, and color.
2. Add that definition to the catalog's `currencies` array.
3. Add costs using its ID to any relevant `UpgradeDefinition`.
4. Add it as a positive amount in a completed `RunResult.rewards` dictionary.
   `RunSession` grants it through `Progression` after validating the result.
5. Document a balancing note in `features/progression/README.md`.

Avoid storing a resource only in a label. `Progression` owns the value so a
save, a shop, a tree, and a later reward summary agree.

## Add an upgrade

Define the cost, prerequisites, maximum level, `cost_growth`, tree position,
and one explicit effect in the catalog. The effect should be a named value the
run can read, such as `starting_health`, `pickup_radius`, or
`run_reward_multiplier`. Use
`Progression.get_effective_stat(&"starting_health", base_health)` in a run
rather than spreading upgrade checks across gameplay scripts.

## Add a run mechanic

Put the mechanic in game/ if it defines the participant's genre. Extract a
component only after a second scene needs the same behavior. Read the active
`RunContext` at start, then return permanent rewards through a completed
`RunResult` instead of writing save data from a random gameplay node.

## Add an interface panel

Start with the shared theme. Make the panel consume a feature's public state
and emit an intention, such as purchase_requested. Let the feature decide
whether the request succeeds, then refresh the panel from the resulting state.

## Replace the supplied demo

Keep app/, features/, ui/, and game/ intact. The starter scenes already satisfy
the documented RunContext and RunResult contract. Remove demo/ when it is no
longer useful, then run `tests/demo_removal_smoke.ps1` to confirm no demo script
is an implicit dependency.
