extends Node
## Versioned, small-scale persistence for foundation settings and future progress.

signal data_saved
signal data_reset

const SAVE_PATH := "user://game_jam_foundation.cfg"
const SAVE_VERSION := 1
const SETTINGS_SECTION := "settings"
const PROGRESS_SECTION := "progress"

var _config := ConfigFile.new()


func _ready() -> void:
	load_from_disk()


func get_setting(key: StringName, fallback: Variant = null) -> Variant:
	return _config.get_value(SETTINGS_SECTION, key, fallback)


func set_setting(key: StringName, value: Variant) -> void:
	_config.set_value(SETTINGS_SECTION, key, value)
	save_to_disk()


func get_progress(key: StringName, fallback: Variant = null) -> Variant:
	return _config.get_value(PROGRESS_SECTION, key, fallback)


func set_progress(key: StringName, value: Variant) -> void:
	_config.set_value(PROGRESS_SECTION, key, value)
	save_to_disk()


func load_from_disk() -> void:
	_config = ConfigFile.new()
	if not FileAccess.file_exists(SAVE_PATH):
		_write_version()
		return
	var result := _config.load(SAVE_PATH)
	if result != OK:
		push_warning("Could not load foundation save data. Defaults will be used.")
		_config = ConfigFile.new()
	_write_version()


func save_to_disk() -> Error:
	_write_version()
	var result := _config.save(SAVE_PATH)
	if result == OK:
		data_saved.emit()
	else:
		push_error("Could not save foundation data: %s" % error_string(result))
	return result


func reset_all() -> Error:
	_config = ConfigFile.new()
	var result := save_to_disk()
	if result == OK:
		data_reset.emit()
	return result


func _write_version() -> void:
	_config.set_value("foundation", "version", SAVE_VERSION)
