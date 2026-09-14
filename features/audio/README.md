# Audio settings

`AudioSettings` is an autoload backed by the checked-in `default_bus_layout`.
It provides Master, Music, and SFX volume values in the range `0.0` to `1.0` and
saves changes through `SaveStore`.

```gdscript
AudioSettings.set_volume(AudioSettings.MUSIC_BUS, 0.5)
var music_volume := AudioSettings.get_volume(AudioSettings.MUSIC_BUS)
```

Route `AudioStreamPlayer` nodes to `Music` or `SFX`; the Master bus receives
both. Add a bus only when it represents a project-wide mix category, then add
it to `AudioSettings.DEFAULT_VOLUMES` and the pause-menu settings page.

The starter camp and run include looping Music-bus streams, and the app shell,
progression panel, and run provide SFX examples. Attach
`components/looping_music.gd` to a music player when the supplied stream should
restart after it finishes.
