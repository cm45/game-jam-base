class_name UpgradeShopItem
extends PanelContainer

signal selected(upgrade_id: StringName)

var _upgrade: UpgradeDefinition

@onready var _title: Label = %Title
@onready var _summary: Label = %Summary


func _ready() -> void:
	%ViewButton.pressed.connect(func() -> void: selected.emit(_upgrade.id))
	refresh()


func set_upgrade(upgrade: UpgradeDefinition) -> void:
	_upgrade = upgrade
	if is_node_ready():
		refresh()


func refresh() -> void:
	if _upgrade == null:
		return
	_title.text = _upgrade.display_name
	_summary.text = "LV %d/%d  •  %s" % [
		Progression.get_upgrade_level(_upgrade.id),
		_upgrade.max_level,
		_format_cost(Progression.get_upgrade_cost(_upgrade.id)),
	]


func _format_cost(cost: Dictionary[StringName, int]) -> String:
	if cost.is_empty():
		return "MAX LEVEL"
	var parts: PackedStringArray = []
	for currency_id: StringName in cost:
		var currency := Progression.CATALOG.get_currency(currency_id)
		parts.append("%d %s" % [cost[currency_id], currency.display_name])
	return " • ".join(parts)
