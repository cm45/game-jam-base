# Meta-progression guide

Open `app/progression_lab.tscn` in the editor and press **F6** to use the
optional developer sandbox. It is not exposed in the player menu.

1. Add Gold and Insight.
2. In **Shop**, purchase **Lucky Satchel** with Gold. Shop improvements are
   independent and may have repeatable ranks with rising Gold prices.
3. Open **Skill Tree**, unlock **Pathfinder** with Insight, then unlock one of
   its branches. Prerequisite lines turn green when the earlier skill is known.
4. Use zoom, fit, and middle-mouse panning to inspect the full tree.
5. Close and reopen the lab to verify the wallet, shop ranks, and skill levels
   persisted separately.
6. Use the pause menu's reset option to clear progression, then confirm the
   lab returns to zero balances and levels.

The lab demonstrates the framework in isolation; it is not a home scene. The
starter camp opens the Shop from the Merchant and Skill Tree from the Mentor.
Both turn off the panel's sandbox tools so progression comes only from a
completed run. Keep the `Progression` API and catalog unchanged unless the
whole project is intentionally changing its permanent-economy rules.
