extends Node
## Checks the reusable RunContext → RunResult reward transaction.
## It restores the local save file, so it is safe to run during development.

const SAVE_PATH := "user://game_jam_foundation.cfg"

var _had_save := false
var _saved_bytes := PackedByteArray()


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_backup_save()
	SaveStore.reset_all()
	Progression.load_progress()
	RunSession.abandon_active_run()

	var context := StarterGame.create_run_context()
	if not _require(context.is_valid(), "Starter context should name two existing scenes."):
		return
	if not _require(RunSession.begin_run(context) == OK, "RunSession should accept a valid context."):
		return
	if not _require(RunSession.get_active_context() == context, "The active context should be readable by the run."):
		return

	var completed_result := RunResult.new(
		context.run_id,
		true,
		{&"gold": 8, &"insight": 1},
		"Contract test reward",
		{&"tokens": 3},
	)
	if not _require(RunSession.complete_run(completed_result) == OK, "Completed result should be accepted."):
		return
	if not _require(Progression.get_balance(&"gold") == 8, "Completed result should grant Gold once."):
		return
	if not _require(Progression.get_balance(&"insight") == 1, "Completed result should grant Insight once."):
		return
	if not _require(RunSession.get_active_context() == null, "Completed runs should clear the transient context."):
		return
	if not _require(RunSession.get_last_result() == completed_result, "Home scenes should receive the latest result."):
		return

	if not _require(RunSession.begin_run(StarterGame.create_run_context()) == OK, "A fresh context should start a later run."):
		return
	var abandoned_result := RunResult.new(StarterGame.RUN_ID, false, {}, "Run abandoned")
	if not _require(RunSession.complete_run(abandoned_result) == OK, "A no-reward incomplete result should be valid."):
		return
	if not _require(Progression.get_balance(&"gold") == 8, "Incomplete runs must not grant permanent rewards."):
		return

	_restore_save()
	print("run_contract_smoke: PASS")
	get_tree().quit(0)


func _require(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error("run_contract_smoke: %s" % message)
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
