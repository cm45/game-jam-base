# Components

Small, optional gameplay building blocks live here. A game can choose only the
components it needs.

- `top_down_player.tscn` moves a `CharacterBody2D` with the shared movement
  actions. Set its speed from a scene; it does not know about progression.
- `interaction_target.gd` emits `activated(actor)` when the player presses
  **E** within its `Area2D`. The owning scene supplies the result.
- `resource_pickup.tscn` emits `picked_up(pickup, amount)` once and then frees
  itself. The owning scene decides which counter or resource receives it.
- `looping_music.gd` can be attached to an `AudioStreamPlayer` on the `Music`
  bus to loop a supplied stream without altering the vendored audio asset.

The home and gameplay example uses all three. Duplicate them into a participant
scene when they fit the game; let the scene owner create a `RunResult` rather
than teaching a component about permanent rewards or scene routing.
