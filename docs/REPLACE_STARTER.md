# Replace the starter and remove the demo

The starter camp and optional demo are reference implementations, not required
parts of a jam game. Keep the foundation services that help your game; replace
the scenes and components that do not fit your genre.

## Keep the small contract

The smallest useful foundation is:

- `app/` for startup, scene routing, the pause menu, and settings;
- `features/run_flow/` for `RunContext`, `RunResult`, and `RunSession`;
- `features/save/` and `features/progression/` when permanent rewards or
  upgrades fit your game; and
- `ui/` for the shared theme and pause/settings menu.

Your home starts a run by putting a valid `RunContext` into `RunSession`. Your
genre-specific run reads that context, then returns one `RunResult` when the
round ends. That is the only connection the foundation requires between home
and gameplay. Read [the run contract](RUN_CONTRACT.md) before changing this
exchange.

## Safe replacement order

1. Duplicate `game/starter_home.tscn`, `game/starter_run.tscn`, and
   `game/starter_game.gd` with names for your game. Change the three scene/ID
   constants in your copied game configuration.
2. Confirm **F5** can start your copied home, begin your copied run, and return
   a completed `RunResult`. Do this before deleting the originals.
3. Set Project Settings > Application > Run > Main Scene to your new home.
   Update SceneRouter.HOME_SCENE and your copied game configuration paths.
4. Remove the components you do not use. `top_down_player`,
   `interaction_target`, and `resource_pickup` are optional; no service imports
   them.
5. Remove `demo/` whenever it stops being useful. Startup opens the camp
   directly; the demo is not on the normal route.
6. Remove preview entries, demo-only save keys, and documentation references
   only after their replacement route works. `demo_last_run` is only used by
   the old demo; it is safe to leave in existing local saves or ignore it.
7. Run `tests/demo_removal_smoke.ps1` and then manually start your own home and
   run using F5.

Do not delete `app/`, `features/`, or `ui/` as a first step. Start with a
working replacement route, then trim a service only when you know your game
will not use it.

## Tower-defense example

A tower-defense run has no player movement, resource pickups, or extraction
exit. The same handoff still fits:

```gdscript
# In game/tower_home.gd, after the player chooses a map.
var context := RunContext.new(
    &"forest_defense",
    "res://game/tower_defense_run.tscn",
    "res://game/tower_home.tscn",
    "Forest Defense",
    {
        &"starting_gold": Progression.get_effective_stat(&"starting_gold", 50.0),
        &"tower_damage": Progression.get_effective_stat(&"tower_damage", 1.0),
    },
    {&"map_id": &"forest", &"wave_count": 12},
)
if RunSession.begin_run(context) == OK:
    SceneRouter.change_to(context.run_scene_path)
```

The tower-defense scene spends `starting_gold`, creates enemies and towers, and
decides what victory means. When the final wave ends, it returns permanent
currency through the same result:

```gdscript
var context := RunSession.get_active_context()
var result := RunResult.new(
    context.run_id,
    true,
    {&"gold": wave_reward, &"insight": boss_insight},
    "Wave %d cleared" % final_wave,
    {&"waves_cleared": final_wave},
)
RunSession.complete_run(result)
SceneRouter.change_to(context.return_scene_path)
```

Use the `RunContext` values you need and ignore the rest. The sample camp,
player, pickups, tents, shop content, and skill nodes can all be replaced.

## Other directions

| Game direction | Replace | Keep from the foundation |
| --- | --- | --- |
| Roguelike | Starter run with rooms, combat, and a death/victory result. | Context/result handoff, settings, and progression effects. |
| Extraction game | Starter run with loot inventory, an extraction zone, and risk/reward rules. | Completed-result rewards and a permanent wallet. |
| Mining game | Starter run with a dig map, haul capacity, and a surface return. | Currencies and the camp/home concept; add your own haul-capacity stat. |
| Entirely custom game | Both starter scenes and optional components. | Only the services and UI your game actually uses. |

If a sample stat does not match your genre, rename it in the progression
catalog and read the new ID from your run. The shop and skill tree are separate
examples: Gold purchases independent improvements; Insight unlocks prerequisite
skill nodes. You may keep either, both, or neither.

## Final removal check

From the project root, run:

```powershell
.\tests\demo_removal_smoke.ps1 -GodotPath "D:\Path\To\godot.exe"
```

Then press **F5**, enter your replacement home, start a round, finish it, and
confirm its reward reaches the home. Headless checks prove dependency and parse
health; only this short manual route confirms your particular controls, art,
and sound.
