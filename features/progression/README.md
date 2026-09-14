# Progression

This feature supplies a configurable permanent wallet, Gold shop, and Insight
skill tree. Visit Merchant or Mentor in `game/home.tscn` to use it before any
genre-specific run or home scene exists.

## Public API

`Progression` is an autoload. Game code should use these methods instead of
reading or writing `SaveStore` directly:

```gdscript
Progression.grant_currency(&"gold", 10)

if Progression.can_purchase_shop(&"lucky_satchel"):
    var result := Progression.try_purchase_shop(&"lucky_satchel")

if Progression.can_unlock_skill(&"pathfinder"):
    var result := Progression.try_unlock_skill(&"pathfinder")

var starting_health := Progression.get_effective_stat(&"starting_health", 5.0)
```

Each purchase method returns a dictionary with `success` and a player-ready
`message`. Both verify cost and completion state; skill unlocks also verify
their prerequisite nodes. `get_upgrade_level()` remains available when a run
only needs an effect and does not care whether it came from shop or skill tree.

## Catalog

[`content/progression_catalog.tres`](content/progression_catalog.tres) is the
single source of editable definitions. It currently demonstrates:

- Two currencies: `gold` and `insight`.
- Six independent Gold shop improvements, including repeatable ranks.
- Six prerequisite-linked Insight skill nodes.
- Additive and multiplicative permanent effects.
- Positions used by the pan-and-zoom skill-tree view.

To add a shop improvement, duplicate an `UpgradeDefinition` subresource, give
it a unique snake_case ID, use only Gold costs, and append it to
`shop_upgrades`. To add a skill, use Insight costs, add prerequisite IDs when
needed, and append it to `skill_nodes`. Keep tree positions inside the current
980×440 skill canvas.

## Effects

Each `StatEffect` has an ID, operation, and value. `Progression` first sums all
owned additive effects, then applies all owned multiplicative effects. For a
base value `b`, the calculation is `(b + all additions) × all multipliers`.
This makes the result deterministic and lets a later run read one final value.

## Persistence and reset

Balances, shop levels, and skill levels are saved separately under
`progression_state` in the existing `SaveStore`. Existing saves with the older
single `upgrade_levels` dictionary migrate by matching each stable ID to its
new shop or skill definition. Definitions remain in the project catalog, so
balancing changes do not rewrite player saves. The shared pause-menu reset
clears the save and tells `Progression` to clear its in-memory state too.

The lab's grant buttons are a review tool. A later playable run will award
currencies through the same `grant_currency()` API after a successful result.

## Active starter effects

Every sample upgrade now affects the playable starter: movement speed (also
in camp), pickup radius, completed-run bonus Gold, reward multiplier, or
Insight reward. Starting Gold, health, and carrying capacity are no longer
sample effects. Old stable upgrade IDs remain so purchased ranks survive:
Deep Pockets becomes Bounty Contract, Camp Tools becomes Field Journal,
Iron Will becomes Far Reach, and Pack Mule becomes Field Scholar.

Movement bonuses are +18/+24 per shop rank, +30 for Pathfinder and +48 for
Trailblazer. RunContext snapshots all five effects when the Scout starts a run.
