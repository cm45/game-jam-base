# Run flow

`RunSession` is the small bridge between a participant's walkable home and a
genre-specific run. It stores only transient state while a run is active; it
does not save unfinished runs or know how a run plays.

## Contract

The home creates a `RunContext`, calls `RunSession.begin_run(context)`, then
uses `SceneRouter.change_to(context.run_scene_path)`. The run reads
`RunSession.get_active_context()`, applies its own completion rule, then passes
a `RunResult` to `RunSession.complete_run(result)`. Successful results commit
their currency rewards through `Progression` and become available to the home
through `RunSession.get_last_result()`.

`RunContext.starting_values` holds values the home calculated for this run,
such as permanent-stat effects. `RunContext.payload` and `RunResult.details`
are genre-specific dictionaries. `RunResult.rewards` is only for persistent
currency IDs from the progression catalog; positive, known rewards are the only
ones the session commits.

Use `RunSession.abandon_active_run()` when a run has an explicit early-exit
path. Starting a fresh context also abandons the old transient context, so a
participant is never blocked by an interrupted prototype run.

Read [the full run contract](../../docs/RUN_CONTRACT.md) before replacing the
starter scenes.
