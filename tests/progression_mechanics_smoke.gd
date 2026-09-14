extends Node
## Verifies Gold shop purchases and Insight skill unlocks remain independent.

func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_backup_save()
	SaveStore.reset_all()
	Progression.load_progress()
	if not _require(Progression.grant_currency(&"gold", 120), "Test setup should grant Gold."):
		return
	if not _require(Progression.grant_currency(&"insight", 20), "Test setup should grant Insight."):
		return
	if not _require(Progression.can_purchase_shop(&"lucky_satchel"), "Gold should buy a shop improvement."):
		return
	if not _require(bool(Progression.try_purchase_shop(&"lucky_satchel").get("success", false)), "Shop purchase should succeed."):
		return
	if not _require(Progression.get_shop_level(&"lucky_satchel") == 1, "Shop ownership should be stored separately."):
		return
	if not _require(not bool(Progression.try_purchase_shop(&"pathfinder").get("success", true)), "A skill should not be purchasable as shop inventory."):
		return
	if not _require(bool(Progression.try_unlock_skill(&"pathfinder").get("success", false)), "Insight should unlock the root skill."):
		return
	if not _require(Progression.get_skill_level(&"pathfinder") == 1, "Skill ownership should be stored separately."):
		return
	if not _require(bool(Progression.try_unlock_skill(&"keen_eye").get("success", false)), "A learned prerequisite should unlock its skill branch."):
		return
	_restore_save()
	print("progression_mechanics_smoke: PASS")
	get_tree().quit(0)


func _require(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error("progression_mechanics_smoke: %s" % message)
	_restore_save()
	get_tree().quit(1)
	return false


func _backup_save() -> void:
	SaveStore.use_temporary_storage(&"progression_mechanics")
	Progression.load_progress()


func _restore_save() -> void:
	SaveStore.restore_default_storage()
	Progression.load_progress()
