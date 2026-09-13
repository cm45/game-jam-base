# Meta-progression guide

Press **F5**, choose **Open Progression Lab**, then use the sandbox currency
buttons to exercise the complete meta-progression loop before gameplay exists.

1. Add Gold and Insight.
2. In **Shop**, select and purchase **Lucky Satchel**.
3. Select **Trail Rations**. It becomes purchasable only after Lucky Satchel.
4. Purchase **Deep Pockets** repeatedly and watch its cost rise per level.
5. In **SkillTree**, inspect the requirement lines: they become green when the
   prerequisite level is met.
6. Close and reopen the lab to verify the wallet and levels persisted.
7. Use the pause menu's reset option to clear progression, then confirm the
   lab returns to zero balances and levels.

The lab demonstrates the framework in isolation; it is not a home scene. The
playable demo now uses a walkable top-down hub and opens
`features/progression/ui/progression_panel.tscn` from its in-world Path Shrine.
The demo turns off the panel's sandbox tools so progression comes only from a
completed run. Keep the `Progression` API and catalog unchanged unless the
whole project is intentionally changing its permanent-economy rules.
