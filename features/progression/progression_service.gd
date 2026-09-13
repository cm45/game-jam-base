extends Node
## Persistent wallet, upgrade purchasing, prerequisites, and calculated effects.

signal currency_changed(currency_id: StringName, new_balance: int)
signal upgrade_purchased(upgrade_id: StringName, new_level: int)
signal progression_reset

const CATALOG: ProgressionCatalog = preload("res://features/progression/content/progression_catalog.tres")
const SAVE_KEY: StringName = &"progression_state"

var _balances: Dictionary[StringName, int] = {}
var _upgrade_levels: Dictionary[StringName, int] = {}


func _ready() -> void:
	SaveStore.data_reset.connect(_on_save_data_reset)
	load_progress()


func load_progress() -> void:
	_balances.clear()
	_upgrade_levels.clear()
	var saved_state: Variant = SaveStore.get_progress(SAVE_KEY, {})
	var saved_balances: Dictionary = saved_state.get("balances", {}) if saved_state is Dictionary else {}
	var saved_levels: Dictionary = saved_state.get("upgrade_levels", {}) if saved_state is Dictionary else {}
	for currency: CurrencyDefinition in CATALOG.currencies:
		_balances[currency.id] = maxi(int(saved_balances.get(String(currency.id), 0)), 0)
	for upgrade: UpgradeDefinition in CATALOG.upgrades:
		_upgrade_levels[upgrade.id] = clampi(int(saved_levels.get(String(upgrade.id), 0)), 0, upgrade.max_level)


func get_balance(currency_id: StringName) -> int:
	return _balances.get(currency_id, 0)


func grant_currency(currency_id: StringName, amount: int) -> bool:
	if amount <= 0 or CATALOG.get_currency(currency_id) == null:
		return false
	_balances[currency_id] = get_balance(currency_id) + amount
	_save_progress()
	currency_changed.emit(currency_id, get_balance(currency_id))
	return true


func get_upgrade_level(upgrade_id: StringName) -> int:
	return _upgrade_levels.get(upgrade_id, 0)


func get_upgrade_cost(upgrade_id: StringName) -> Dictionary[StringName, int]:
	var upgrade := CATALOG.get_upgrade(upgrade_id)
	if upgrade == null or get_upgrade_level(upgrade_id) >= upgrade.max_level:
		return {}
	return upgrade.get_cost_for_level(get_upgrade_level(upgrade_id) + 1)


func get_unmet_requirements(upgrade_id: StringName) -> Array[UpgradeRequirement]:
	var unmet: Array[UpgradeRequirement] = []
	var upgrade := CATALOG.get_upgrade(upgrade_id)
	if upgrade == null:
		return unmet
	for requirement: UpgradeRequirement in upgrade.prerequisites:
		if get_upgrade_level(requirement.upgrade_id) < requirement.required_level:
			unmet.append(requirement)
	return unmet


func can_purchase(upgrade_id: StringName) -> bool:
	var upgrade := CATALOG.get_upgrade(upgrade_id)
	if upgrade == null or get_upgrade_level(upgrade_id) >= upgrade.max_level:
		return false
	if not get_unmet_requirements(upgrade_id).is_empty():
		return false
	for currency_id: StringName in get_upgrade_cost(upgrade_id):
		if get_balance(currency_id) < get_upgrade_cost(upgrade_id)[currency_id]:
			return false
	return true


func try_purchase(upgrade_id: StringName) -> Dictionary:
	var upgrade := CATALOG.get_upgrade(upgrade_id)
	if upgrade == null:
		return {"success": false, "message": "Unknown upgrade."}
	if get_upgrade_level(upgrade_id) >= upgrade.max_level:
		return {"success": false, "message": "This upgrade is already maxed."}
	var unmet := get_unmet_requirements(upgrade_id)
	if not unmet.is_empty():
		return {"success": false, "message": "Purchase the required upgrade first."}
	var cost := get_upgrade_cost(upgrade_id)
	for currency_id: StringName in cost:
		if get_balance(currency_id) < cost[currency_id]:
			return {"success": false, "message": "Not enough %s." % CATALOG.get_currency(currency_id).display_name}
	for currency_id: StringName in cost:
		_balances[currency_id] = get_balance(currency_id) - cost[currency_id]
		currency_changed.emit(currency_id, get_balance(currency_id))
	_upgrade_levels[upgrade_id] = get_upgrade_level(upgrade_id) + 1
	_save_progress()
	upgrade_purchased.emit(upgrade_id, get_upgrade_level(upgrade_id))
	return {"success": true, "message": "%s upgraded." % upgrade.display_name}


func get_effective_stat(stat_id: StringName, base_value: float = 0.0) -> float:
	var additive := 0.0
	var multiplier := 1.0
	for upgrade: UpgradeDefinition in CATALOG.upgrades:
		var owned_levels := get_upgrade_level(upgrade.id)
		if owned_levels == 0:
			continue
		for effect: StatEffect in upgrade.effects:
			if effect.stat_id != stat_id:
				continue
			if effect.operation == StatEffect.Operation.MULTIPLY:
				multiplier *= pow(effect.value, owned_levels)
			else:
				additive += effect.value * owned_levels
	return (base_value + additive) * multiplier


func reset_progress() -> void:
	_balances.clear()
	_upgrade_levels.clear()
	_save_progress()
	progression_reset.emit()


func _save_progress() -> void:
	var saved_balances: Dictionary[String, int] = {}
	var saved_levels: Dictionary[String, int] = {}
	for currency_id: StringName in _balances:
		saved_balances[String(currency_id)] = _balances[currency_id]
	for upgrade_id: StringName in _upgrade_levels:
		saved_levels[String(upgrade_id)] = _upgrade_levels[upgrade_id]
	SaveStore.set_progress(SAVE_KEY, {"balances": saved_balances, "upgrade_levels": saved_levels})


func _on_save_data_reset() -> void:
	_balances.clear()
	_upgrade_levels.clear()
	progression_reset.emit()
