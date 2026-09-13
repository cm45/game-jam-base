# Save store

`SaveStore` writes one versioned `ConfigFile` at
`user://game_jam_foundation.cfg`. It has separate settings and progress
sections so temporary UI configuration and future meta-progression do not need
different save systems.

```gdscript
SaveStore.set_progress(&"training_tokens", 5)
var tokens := int(SaveStore.get_progress(&"training_tokens", 0))
```

`reset_all()` clears both sections and immediately writes the current save
version. The shared pause menu exposes this with an explicit confirmation. Do
not use this store for mid-run state in the foundation; that decision belongs to
the run contract in a later milestone.
