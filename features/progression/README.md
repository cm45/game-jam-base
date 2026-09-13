# Progression

This feature supplies a configurable, permanent wallet and upgrade system. It
is fully runnable in `app/progression_lab.tscn` before any genre-specific run or
home scene exists.

## Public API

`Progression` is an autoload. Game code should use these methods instead of
reading or writing `SaveStore` directly:

```gdscript
Progression.grant_currency(&"gold", 10)

if Progression.can_purchase(&"lucky_satchel"):
    var result := Progression.try_purchase(&"lucky_satchel")

var starting_health := Progression.get_effective_stat(&"starting_health", 5.0)
```

`try_purchase()` returns a dictionary with `success` and a player-ready
`message`. It checks that the upgrade exists, is not maxed, has met every
requirement, and can afford every currency before changing anything.

## Catalog

[`content/progression_catalog.tres`](content/progression_catalog.tres) is the
single source of editable definitions. It currently demonstrates:

- Two currencies: `gold` and `insight`.
- A required upgrade chain.
- A three-level upgrade with increasing costs.
- Additive and multiplicative permanent effects.
- Positions used by the skill-tree view.

To add an upgrade, duplicate an `UpgradeDefinition` subresource, give it a
unique snake_case ID, add costs and effects, then append it to the catalog's
`upgrades` array. Keep positions inside the current 480×238 skill-tree canvas.

## Effects

Each `StatEffect` has an ID, operation, and value. `Progression` first sums all
owned additive effects, then applies all owned multiplicative effects. For a
base value `b`, the calculation is `(b + all additions) × all multipliers`.
This makes the result deterministic and lets a later run read one final value.

## Persistence and reset

Only balances and upgrade levels are saved under `progression_state` in the
existing `SaveStore`. Definitions remain in the project catalog, so balancing
changes do not rewrite player saves. The shared pause-menu reset clears the
save and tells `Progression` to clear its in-memory state too.

The lab's grant buttons are a review tool. A later playable run will award
currencies through the same `grant_currency()` API after a successful result.
