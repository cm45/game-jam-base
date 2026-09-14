# Architecture

Start with [game/README.md](../game/README.md): it explains where to edit the
maps and gameplay. This project has one playable example, not competing demo
and starter implementations.

| Folder | Purpose |
| --- | --- |
| `game/` | Your home, gameplay, map tiles, and game configuration. |
| `features/` | Reusable progression, saving, audio, input, and run flow. |
| `components/` | Optional player movement, pickups, interactions, and music nodes. |
| `ui/` | Shared wood theme, readable font, and pause/settings menu. |
| `app/` | Persistent application shell and scene routing. |
| `tests/` | Automated checks; no player-facing laboratory scenes. |
| `docs/` | Setup, editing, extension, AI, and release guides. |
| `assets/` | Original Ninja Adventure pack and attribution. |
| `addons/` | The pinned optional Godot MCP editor integration. |

## The playable flow

F5 loads `game/home.tscn`. Merchant opens the Gold shop, Mentor opens the
Insight skill tree, and Scout starts `game/gameplay.tscn`.
Both maps use saved TileMapLayer nodes under Terrain for editable grass/paths.

`game/game_definition.gd` owns the paths and creates RunContext, including
the effects of owned upgrades. Gameplay owns its objective and returns
RunResult once it finishes. RunSession validates and commits rewards.
A run simply means a gameplay session; it can have any genre or controls.

## Services

| Autoload | Responsibility |
| --- | --- |
| InputActions | Named actions and binding descriptions. |
| SaveStore | Settings and permanent progress on disk. |
| Progression | Currencies, purchases, skills, prerequisites, calculated effects. |
| AudioSettings | Master/Music/SFX volumes. |
| RunSession | Transient context and validated one-time result handoff. |
| SceneRouter | Scene changes. |
| AppShell | Pause/settings UI above every game scene. |

The progression catalog holds editable definitions; saves store balances and
owned levels. Shop and skill windows belong to features/progression/ui/.
Neither the player nor a pickup writes saves or decides scene routes.

## Where to put new code

Put game-specific rules in game/. Put a reusable system in features/, its
optional scene building blocks in components/, and shared presentation in ui/.
Keep tests out of playable scenes. Name files after concepts, using snake_case.
Avoid managers or duplicate examples until an actual consumer needs them.

See [RunContext/RunResult](RUN_CONTRACT.md), [extension recipes](EXTENSION_RECIPES.md),
and [replacing the example](REPLACE_STARTER.md).
