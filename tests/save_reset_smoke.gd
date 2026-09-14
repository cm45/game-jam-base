extends Node
## Verifies that settings and progression persist, then reset together.
## The test runs in a temporary SaveStore file and leaves the local save alone.
const TEST_SETTING: StringName = &"release_smoke_volume"

var _reset_received := false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_backup_save()
	SaveStore.data_reset.connect(_on_data_reset)
	SaveStore.reset_all()
	Progression.load_progress()
	if not _require(Progression.get_balance(&"gold") == 0, "A reset save should start with no Gold."):
		return
	SaveStore.set_progress(Progression.SAVE_KEY, {
		"balances": {"gold": 17, "insight": 5},
		"upgrade_levels": {"lucky_satchel": 1, "deep_pockets": 2, "pathfinder": 1},
	})
	Progression.load_progress()
	if not _require(Progression.get_shop_level(&"lucky_satchel") == 1, "Legacy shop levels should migrate into shop storage."):
		return
	if not _require(Progression.get_shop_level(&"deep_pockets") == 2, "Legacy multi-rank shop levels should migrate."):
		return
	if not _require(Progression.get_skill_level(&"pathfinder") == 1, "Legacy skill levels should migrate into skill storage."):
		return
	var migrated_state: Variant = SaveStore.get_progress(Progression.SAVE_KEY, {})
	if not _require(migrated_state is Dictionary and migrated_state.has("shop_levels") and migrated_state.has("skill_levels"), "Migration should save separate shop and skill sections."):
		return
	SaveStore.reset_all()
	Progression.load_progress()

	SaveStore.set_setting(TEST_SETTING, 0.35)
	if not _require(is_equal_approx(float(SaveStore.get_setting(TEST_SETTING, -1.0)), 0.35), "A setting should be readable after saving."):
		return
	if not _require(Progression.grant_currency(&"gold", 9), "Gold setup should save through Progression."):
		return

	SaveStore.load_from_disk()
	Progression.load_progress()
	if not _require(is_equal_approx(float(SaveStore.get_setting(TEST_SETTING, -1.0)), 0.35), "A setting should survive a disk reload."):
		return
	if not _require(Progression.get_balance(&"gold") == 9, "Progression should survive a disk reload."):
		return

	_reset_received = false
	if not _require(SaveStore.reset_all() == OK, "Reset should write a clean save."):
		return
	if not _require(_reset_received, "Reset should notify progression listeners."):
		return
	if not _require(SaveStore.get_setting(TEST_SETTING, null) == null, "Reset should clear saved settings."):
		return
	if not _require(Progression.get_balance(&"gold") == 0, "Reset should clear progression balances."):
		return

	SaveStore.load_from_disk()
	Progression.load_progress()
	if not _require(SaveStore.get_setting(TEST_SETTING, null) == null, "A reloaded reset save should stay empty."):
		return
	if not _require(Progression.get_balance(&"gold") == 0, "A reloaded reset save should have no Gold."):
		return

	_restore_save()
	print("save_reset_smoke: PASS")
	get_tree().quit(0)


func _on_data_reset() -> void:
	_reset_received = true


func _require(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error("save_reset_smoke: %s" % message)
	_restore_save()
	get_tree().quit(1)
	return false


func _backup_save() -> void:
	SaveStore.use_temporary_storage(&"save_reset")
	Progression.load_progress()


func _restore_save() -> void:
	SaveStore.restore_default_storage()
	Progression.load_progress()
