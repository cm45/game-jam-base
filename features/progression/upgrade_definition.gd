class_name UpgradeDefinition
extends Resource
## Data for an upgrade purchasable with one or more currencies.

@export var id: StringName
@export var display_name := "Unnamed upgrade"
@export_multiline var description := ""
@export var costs: Dictionary = {}
@export_range(1, 99, 1) var max_level := 1
@export_range(1.0, 5.0, 0.05) var cost_growth := 1.0
@export var prerequisites: Array[UpgradeRequirement] = []
@export var effects: Array[StatEffect] = []
@export var tree_position := Vector2.ZERO


func get_cost_for_level(next_level: int) -> Dictionary[StringName, int]:
	var level_index := maxi(next_level - 1, 0)
	var scaled_costs: Dictionary[StringName, int] = {}
	for currency_id: Variant in costs:
		var base_cost := int(costs[currency_id])
		scaled_costs[StringName(currency_id)] = ceili(base_cost * pow(cost_growth, level_index))
	return scaled_costs
