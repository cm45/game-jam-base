# Save store

`SaveStore` writes one versioned `ConfigFile` at
`user://game_jam_foundation.cfg`. It has separate settings and progress
sections so temporary UI configuration and meta-progression do not need
different save systems. The `Progression` service owns the current
`progression_state` value in the progress section.

```gdscript
SaveStore.set_progress(&"training_tokens", 5)
var tokens := int(SaveStore.get_progress(&"training_tokens", 0))
```

`get_setting()` and `get_progress()` return their fallback exactly, including a
`null` fallback when a key has not been stored.

`reset_all()` clears both sections and immediately writes the current save
version. The shared pause menu exposes this with an explicit confirmation. Do
not use this store for mid-run state in the foundation; that decision belongs to
the run contract.

The automated smoke scenes temporarily switch this service to an isolated
`user://game_jam_foundation_test_*.cfg` file. Game code should keep using the
normal save and should not call `use_temporary_storage()`.
