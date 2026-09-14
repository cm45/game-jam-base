extends Node
## Checks the reusable RunContext → RunResult reward transaction.
## It uses a temporary SaveStore file, so it is safe to run during development.


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_backup_save()
	SaveStore.reset_all()
	Progression.load_progress()
	RunSession.abandon_active_run()

	var context := GameDefinition.create_run_context()
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

	if not _require(RunSession.begin_run(GameDefinition.create_run_context()) == OK, "A fresh context should start a later run."):
		return
	var abandoned_result := RunResult.new(GameDefinition.RUN_ID, false, {}, "Run abandoned")
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
	SaveStore.use_temporary_storage(&"run_contract")
	Progression.load_progress()


func _restore_save() -> void:
	SaveStore.restore_default_storage()
	Progression.load_progress()
