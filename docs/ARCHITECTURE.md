# Architecture overview

The foundation uses a feature-oriented layout so a small game can grow without
every system being mixed into one scene. A feature owns its data, behavior, and
UI where that keeps the concept easy to find. Shared helpers stay separate only
when more than one feature needs them.

| Location | Put this here | Do not put this here |
| --- | --- | --- |
| app/ | Startup, global flow, and later autoload services. | Genre-specific game rules. |
| features/ | A reusable capability such as saving, progression, or audio. | A one-off visual node. |
| components/ | Small optional nodes such as an interaction area or health bar. | A service that owns player progress. |
| game/ | The minimal home and run scenes a participant adapts. | Demonstration-only content. |
| demo/ | A complete example that proves the framework contract. | Required foundation dependencies. |
| ui/ | Shared themes, widgets, and menus. | Resource or combat rules. |
| assets/ | Vendored packs and new project art. | Generated Godot import files. |

## Scene ownership

Each scene should have a clear owner. A home scene owns a walkable 2D map, its
player spawn, NPCs, stations, and the start-of-run exit; it asks a service for
progress when one of those world interactions opens a panel. A run scene owns
the moment-to-moment game and returns a result when it ends. A menu owns its
controls and emits an intent; it does not change a game system behind the
caller's back.

The current shell introduces only services with active consumers: the pause
menu uses input, audio, and save services, while the Foundation Hub uses the
scene router. The playable demo owns its world scenes under `demo/` and calls
the same services through their public APIs. The participant-owned starter
scenes live under `game/` and use `RunSession` for their home → run handoff.

## Core services

| Service | Owner | Public responsibility |
| --- | --- | --- |
| `InputActions` | `features/input/` | Registers shared action names and supplies readable binding text. |
| `AudioSettings` | `features/audio/` | Applies and persists Master, Music, and SFX volumes. |
| `SaveStore` | `features/save/` | Stores versioned settings now and a reserved progress section later. |
| `Progression` | `features/progression/` | Owns permanent currencies, upgrades, purchases, requirements, and calculated effects. |
| `RunSession` | `features/run_flow/` | Carries a transient context into a run, validates its result, and commits completed rewards. |
| `SceneRouter` | `app/` | Changes scenes and provides the return-to-hub route. |
| `AppShell` | `app/` | Keeps the pause menu available across scene changes. |

Services communicate through their public methods and signals. A menu never
reaches into a game scene to change its state; a game scene never edits a UI
control to save data.

## Progression ownership

`features/progression/content/progression_catalog.tres` holds editable resource
definitions. The `Progression` autoload loads that catalog and serializes only
the wallet and upgrade levels; UI and game scenes ask it questions through
methods rather than writing the save directly. Its shop and tree UI live beside
the feature. `app/progression_lab.tscn` is a host for reviewing it in isolation,
while the demo home instances the same panel from its Path Shrine.

## Starter and demonstration ownership

`game/starter_home.tscn` is an actual 2D camp hub: it owns its player spawn,
outdoor NPC stations, scenery, and run entrance. It creates a `RunContext`,
then `game/starter_run.tscn` owns the pickup count and completion rule. The run
returns a `RunResult`; `RunSession` commits its persistent rewards and the home
shows the result. The longer `demo/` example remains separate and optional.

`components/` supplies movement, interaction, and pickup events to both scenes.
Those components do not know which scene receives a reward, opens a panel, or
changes route. The starter scenes are the reusable contract reference; the
demonstration's old display-only last-run message remains confined to `demo/`.
The [replacement guide](REPLACE_STARTER.md) maps this contract to tower defense,
roguelike, extraction, mining, and fully custom games.

## Choosing a location

Ask these questions before creating a file:

1. Is this game-specific and used by one participant scene? Put it in game/.
2. Could another jam game reuse it with only configuration changes? Put it in a
   feature folder.
3. Is it a small node that can be dropped into several scenes? Put it in
   components/.
4. Is it only there to teach or prove the contract? Put it in demo/.

Use a README beside a new feature to state its purpose, entry point, configured
values, and one way to extend it.

## Naming

Use folders and scene names that describe a game concept, such as
progression/, run_exit/, or resource_wallet/. Use PascalCase for classes and
scene root nodes, snake_case for files, variables, functions, and signals.
Name a signal after the event it announces, for example reward_claimed.
