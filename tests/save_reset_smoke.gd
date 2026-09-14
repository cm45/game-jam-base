extends Node
## Verifies that settings and progression persist, then reset together.
## The existing local save is restored before this scene closes.

const SAVE_PATH := "user://game_jam_foundation.cfg"
const TEST_SETTING: StringName = &"release_smoke_volume"

var _had_save := false
var _saved_bytes := PackedByteArray()
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
	var absolute_path := ProjectSettings.globalize_path(SAVE_PATH)
	_had_save = FileAccess.file_exists(absolute_path)
	if _had_save:
		_saved_bytes = FileAccess.get_file_as_bytes(absolute_path)


func _restore_save() -> void:
	var absolute_path := ProjectSettings.globalize_path(SAVE_PATH)
	if _had_save:
		var file := FileAccess.open(absolute_path, FileAccess.WRITE)
		file.store_buffer(_saved_bytes)
	else:
		DirAccess.remove_absolute(absolute_path)
	SaveStore.load_from_disk()
	Progression.load_progress()