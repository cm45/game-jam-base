extends Node
## Carries a transient RunContext into a run and commits its RunResult once.
##
## There are deliberately no mid-run saves here. A fresh `begin_run()` replaces
## an abandoned context, which keeps the weekend foundation recoverable after a
## participant restarts or changes direction.

signal run_started(context: RunContext)
signal run_finished(result: RunResult)
signal run_abandoned(context: RunContext)

var _active_context: RunContext
var _last_result: RunResult


func begin_run(context: RunContext) -> Error:
	if context == null or not context.is_valid():
		push_error("RunSession requires a valid RunContext.")
		return ERR_INVALID_PARAMETER
	if _active_context != null:
		run_abandoned.emit(_active_context)
	_active_context = context
	_last_result = null
	run_started.emit(context)
	return OK


func get_active_context() -> RunContext:
	return _active_context


func get_last_result() -> RunResult:
	return _last_result


func abandon_active_run() -> void:
	if _active_context == null:
		return
	var abandoned_context := _active_context
	_active_context = null
	run_abandoned.emit(abandoned_context)


func complete_run(result: RunResult) -> Error:
	if _active_context == null:
		push_error("RunSession cannot complete a run without an active context.")
		return ERR_UNAVAILABLE
	if result == null or not result.is_valid() or result.run_id != _active_context.run_id:
		push_error("RunSession received an invalid or mismatched RunResult.")
		return ERR_INVALID_DATA
	if result.completed and not _rewards_are_known(result.rewards):
		push_error("RunSession received a reward for an unknown progression currency.")
		return ERR_INVALID_DATA
	if result.completed:
		for currency_id: Variant in result.rewards:
			Progression.grant_currency(StringName(currency_id), int(result.rewards[currency_id]))
	_last_result = result
	_active_context = null
	run_finished.emit(result)
	return OK


func _rewards_are_known(rewards: Dictionary) -> bool:
	for currency_id: Variant in rewards:
		if Progression.CATALOG.get_currency(StringName(currency_id)) == null:
			return false
	return true
