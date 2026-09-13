# Features

Reusable systems such as saving, settings, scene flow, resources, and
progression live here. Milestone 2 adds three small services:

- `input/` registers shared input action names and their starter bindings.
- `audio/` owns the Master, Music, and SFX bus volumes.
- `save/` persists versioned settings and provides the future progression save
  section.

Each feature folder documents its public methods. Keep a genre-specific system
in `game/` until a second scene or participant needs it.
