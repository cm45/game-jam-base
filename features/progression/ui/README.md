# Progression UI

Skill nodes use `skill_tree_button.gd` for compact wood tooltips with a pixel
heading and wrapped readable body text. Native tooltip popups bypass the
half-scale UIScreen layout, so their width and font sizes are specified in
640×360 viewport units. Keep these sizes independent of skill-tree zoom.
The skill button uses an empty `TooltipPanel` wrapper style so only the custom
wood panel draws, without Godot's default dark background or extra padding.

`progression_panel.tscn` contains the wallet, sandbox controls, selected
details, and separate **Shop** and **Skill Tree** views. It listens to
`Progression` signals and never changes saved state itself. Gold purchases use
`Progression.try_purchase_shop()`; Insight skills use
`Progression.try_unlock_skill()`.

The Shop uses a single readable list: six example improvements fit before
scrolling. The Skill Tree uses its own 980×440 canvas with zoom, fit, and
middle-mouse panning. Keep new positions inside that canvas.

Use `show_sandbox_tools = false` for a real home scene. The starter camp does
that at its Merchant and Mentor stations, so players earn currency through a
run instead of its review buttons. `close_button_text` lets a scene use a
contextual close label without changing this shared panel.

`progression_tree.gd` draws prerequisite lines and creates one selectable node
per skill definition. `tree_position` in the catalog controls its layout. Keep
a connection readable, use requirements only for actual unlock rules, and do
not encode progression state into scene-node names or colors.

## Separate camp windows

Instance `shop_window.tscn` at a merchant and `skill_tree_window.tscn` at a
mentor. Each locks its content and selection to that system and hides the tab
bar. They share layout and purchase logic through `progression_panel.tscn`.
The combined panel is a shared implementation exercised by automated tests;
players use only the two station windows. The camp keeps separate window instances and
closes the other window before opening a station.
