class_name ProgressionCatalog
extends Resource
## The editable list of currencies, shop improvements, and skill nodes.

@export var currencies: Array[CurrencyDefinition] = []
@export var shop_upgrades: Array[UpgradeDefinition] = []
@export var skill_nodes: Array[UpgradeDefinition] = []


var upgrades: Array[UpgradeDefinition]:
	get:
		return get_all_upgrades()


func get_currency(currency_id: StringName) -> CurrencyDefinition:
	for currency: CurrencyDefinition in currencies:
		if currency.id == currency_id:
			return currency
	return null


func get_upgrade(upgrade_id: StringName) -> UpgradeDefinition:
	for upgrade: UpgradeDefinition in get_all_upgrades():
		if upgrade.id == upgrade_id:
			return upgrade
	return null


func get_all_upgrades() -> Array[UpgradeDefinition]:
	var combined: Array[UpgradeDefinition] = []
	combined.append_array(shop_upgrades)
	combined.append_array(skill_nodes)
	return combined


func is_shop_upgrade(upgrade_id: StringName) -> bool:
	return _contains_upgrade(shop_upgrades, upgrade_id)


func is_skill_node(upgrade_id: StringName) -> bool:
	return _contains_upgrade(skill_nodes, upgrade_id)


func _contains_upgrade(items: Array[UpgradeDefinition], upgrade_id: StringName) -> bool:
	for item: UpgradeDefinition in items:
		if item.id == upgrade_id:
			return true
	return false
