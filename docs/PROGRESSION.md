# Progression

Press F5 and visit Merchant for the Gold shop or Mentor for Insight skills.
The shop and skill windows are separate. Earn currency by completing gameplay;
developer checks can grant isolated test currency without affecting your save.

The catalog is `features/progression/content/progression_catalog.tres`.
Expand shop_upgrades or skill_nodes in the Inspector to change an item.
Each definition has a stable ID, display name, description, costs, rank limit,
and effects. Skills can also have prerequisites and a tree position.

Use the [feature README](../features/progression/README.md) for the public API.
Use [the UI README](../features/progression/ui/README.md) for presentation changes.

All sample effects are consumed by gameplay: movement, pickup reach, bonus
Gold, reward multiplier, and Insight rewards. Movement also applies in home.
GameDefinition snapshots them into the next RunContext.

Purchase an upgrade, start another session, and check its effect. Fit shows
the whole skill tree; zoom and middle-mouse drag explore it. Settings > Reset
clears progression and settings after confirmation.
