# Progression UI

`progression_panel.tscn` contains the wallet, sandbox controls, shop, selected
upgrade details, and two tabs: **Shop** and **SkillTree**. It listens to
`Progression` signals and never changes saved state itself; purchases always go
through `Progression.try_purchase()`.

The Shop uses compact two-column cards: three rows show six upgrades before
scrolling. The 480×144 SkillTree canvas is sized to show the current graph in
the same viewport. Keep new tree positions inside that canvas.

Use `show_sandbox_tools = false` for a real home scene. The demo does that at
its Path Shrine, so players earn currency through a run instead of its review
buttons. `close_button_text` lets a scene use a contextual close label without
changing this shared panel.

`progression_tree.gd` draws prerequisite lines and creates one selectable node
per upgrade definition. `tree_position` in the catalog controls its layout.
Keep a connection readable, use requirements only for actual purchase rules,
and do not encode progression state into scene-node names or colors.
