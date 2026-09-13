# Input actions

`InputActions` is an autoload that registers a small starter vocabulary at
runtime. It never overwrites an existing Input Map entry, which leaves room for
a later rebinding feature.

| Action | Default keys | Intended use |
| --- | --- | --- |
| `move_up`, `move_down`, `move_left`, `move_right` | WASD and arrow keys | Top-down movement in games that need it. |
| `interact` | E | Talk, collect, enter, or activate. |
| `pause` | Escape | Toggle the persistent pause menu. |
| `confirm` | Enter or Space | Confirm a focused control. |
| `cancel` | Escape | Cancel a focused control. |

Use the `InputActions` constants in scripts. For example,
`Input.is_action_just_pressed(InputActions.INTERACT)` is clearer and safer than
repeating `"interact"` in many files.
