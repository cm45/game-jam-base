# Progression UI

`progression_panel.tscn` contains the wallet, sandbox controls, shop, selected
upgrade details, and two tabs: **Shop** and **SkillTree**. It listens to
`Progression` signals and never changes saved state itself; purchases always go
through `Progression.try_purchase()`.

`progression_tree.gd` draws prerequisite lines and creates one selectable node
per upgrade definition. `tree_position` in the catalog controls its layout.
Keep a connection readable, use requirements only for actual purchase rules,
and do not encode progression state into scene-node names or colors.
