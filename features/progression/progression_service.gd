extends Node
## Persistent wallet, shop purchases, skill unlocks, and calculated effects.

signal currency_changed(currency_id: StringName, new_balance: int)
signal shop_purchased(upgrade_id: StringName, new_level: int)
signal skill_unlocked(skill_id: StringName, new_level: int)
signal upgrade_purchased(upgrade_id: StringName, new_level: int)
signal progression_reset

const CATALOG: ProgressionCatalog = preload("res://features/progression/content/progression_catalog.tres")
const SAVE_KEY: StringName = &"progression_state"

var _balances: Dictionary[StringName, int] = {}
var _shop_levels: Dictionary[StringName, int] = {}
var _skill_levels: Dictionary[StringName, int] = {}


func _ready() -> void:
	SaveStore.data_reset.connect(_on_save_data_reset)
	load_progress()


func load_progress() -> void:
	_balances.clear()
	_shop_levels.clear()
	_skill_levels.clear()
	var saved_state: Variant = SaveStore.get_progress(SAVE_KEY, {})
	var state: Dictionary = saved_state if saved_state is Dictionary else {}
	var saved_balances: Dictionary = state.get("balances", {})
	var saved_shop_levels: Dictionary = state.get("shop_levels", {})
	var saved_skill_levels: Dictionary = state.get("skill_levels", {})
	var legacy_levels: Dictionary = state.get("upgrade_levels", {})
	for currency: CurrencyDefinition in CATALOG.currencies:
		_balances[currency.id] = maxi(int(saved_balances.get(String(currency.id), 0)), 0)
	for upgrade: UpgradeDefinition in CATALOG.shop_upgrades:
		_shop_levels[upgrade.id] = _load_level(saved_shop_levels, legacy_levels, upgrade)
	for skill: UpgradeDefinition in CATALOG.skill_nodes:
		_skill_levels[skill.id] = _load_level(saved_skill_levels, legacy_levels, skill)
	if not legacy_levels.is_empty() and saved_shop_levels.is_empty() and saved_skill_levels.is_empty():
		_save_progress()


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
	if CATALOG.is_shop_upgrade(upgrade_id):
		return get_shop_level(upgrade_id)
	return get_skill_level(upgrade_id)


func get_shop_level(upgrade_id: StringName) -> int:
	return _shop_levels.get(upgrade_id, 0)


func get_skill_level(skill_id: StringName) -> int:
	return _skill_levels.get(skill_id, 0)


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


func can_purchase_shop(upgrade_id: StringName) -> bool:
	return CATALOG.is_shop_upgrade(upgrade_id) and can_purchase(upgrade_id)


func can_unlock_skill(skill_id: StringName) -> bool:
	return CATALOG.is_skill_node(skill_id) and can_purchase(skill_id)


func try_purchase(upgrade_id: StringName) -> Dictionary:
	if CATALOG.is_shop_upgrade(upgrade_id):
		return try_purchase_shop(upgrade_id)
	return try_unlock_skill(upgrade_id)


func try_purchase_shop(upgrade_id: StringName) -> Dictionary:
	if not CATALOG.is_shop_upgrade(upgrade_id):
		return {"success": false, "message": "This improvement belongs in the skill tree."}
	return _try_purchase(upgrade_id, true)


func try_unlock_skill(skill_id: StringName) -> Dictionary:
	if not CATALOG.is_skill_node(skill_id):
		return {"success": false, "message": "This skill belongs in the shop."}
	return _try_purchase(skill_id, false)


func _try_purchase(upgrade_id: StringName, is_shop_purchase: bool) -> Dictionary:
	var upgrade := CATALOG.get_upgrade(upgrade_id)
	if upgrade == null:
		return {"success": false, "message": "Unknown improvement."}
	if get_upgrade_level(upgrade_id) >= upgrade.max_level:
		return {"success": false, "message": "This improvement is already complete."}
	var unmet := get_unmet_requirements(upgrade_id)
	if not unmet.is_empty():
		return {"success": false, "message": "Unlock the required skill first."}
	var cost := get_upgrade_cost(upgrade_id)
	for currency_id: StringName in cost:
		if get_balance(currency_id) < cost[currency_id]:
			return {"success": false, "message": "Not enough %s." % CATALOG.get_currency(currency_id).display_name}
	for currency_id: StringName in cost:
		_balances[currency_id] = get_balance(currency_id) - cost[currency_id]
		currency_changed.emit(currency_id, get_balance(currency_id))
	if is_shop_purchase:
		_shop_levels[upgrade_id] = get_upgrade_level(upgrade_id) + 1
		shop_purchased.emit(upgrade_id, _shop_levels[upgrade_id])
	else:
		_skill_levels[upgrade_id] = get_upgrade_level(upgrade_id) + 1
		skill_unlocked.emit(upgrade_id, _skill_levels[upgrade_id])
	_save_progress()
	upgrade_purchased.emit(upgrade_id, get_upgrade_level(upgrade_id))
	return {"success": true, "message": "%s unlocked." % upgrade.display_name}


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
	_shop_levels.clear()
	_skill_levels.clear()
	_save_progress()
	progression_reset.emit()


func _save_progress() -> void:
	var saved_balances: Dictionary[String, int] = {}
	var saved_shop_levels: Dictionary[String, int] = {}
	var saved_skill_levels: Dictionary[String, int] = {}
	for currency_id: StringName in _balances:
		saved_balances[String(currency_id)] = _balances[currency_id]
	for upgrade_id: StringName in _shop_levels:
		saved_shop_levels[String(upgrade_id)] = _shop_levels[upgrade_id]
	for skill_id: StringName in _skill_levels:
		saved_skill_levels[String(skill_id)] = _skill_levels[skill_id]
	SaveStore.set_progress(SAVE_KEY, {
		"schema": 2,
		"balances": saved_balances,
		"shop_levels": saved_shop_levels,
		"skill_levels": saved_skill_levels,
	})


func _on_save_data_reset() -> void:
	_balances.clear()
	_shop_levels.clear()
	_skill_levels.clear()
	progression_reset.emit()


func _load_level(primary_levels: Dictionary, legacy_levels: Dictionary, upgrade: UpgradeDefinition) -> int:
	var raw_level: Variant = primary_levels.get(String(upgrade.id), legacy_levels.get(String(upgrade.id), 0))
	return clampi(int(raw_level), 0, upgrade.max_level)
