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

Each scene should have a clear owner. A home scene owns home presentation and
asks a service for progress. A run scene owns the moment-to-moment game and
returns a result when it ends. A menu owns its controls and emits an intent; it
does not change a game system behind the caller's back.

This separation is introduced across later milestones. Milestone 1 contains
only the runnable preview, so do not add placeholder autoloads or empty manager
scripts before a feature needs them.

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
