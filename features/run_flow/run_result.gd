class_name RunResult
extends RefCounted
## Outcome returned by a run scene when its completion rule has been reached.
##
## `rewards` contains only permanent currency rewards. Keep scores, collected
## items, or genre-specific information in `details` so the home can present it
## without coupling the framework to a particular genre.

var run_id: StringName
var completed := false
var rewards: Dictionary = {}
var summary := ""
var details: Dictionary = {}


func _init(
		id: StringName = &"",
		was_completed := false,
		granted_rewards: Dictionary = {},
		result_summary := "",
		result_details: Dictionary = {},
	) -> void:
	run_id = id
	completed = was_completed
	rewards = granted_rewards.duplicate(true)
	summary = result_summary
	details = result_details.duplicate(true)


func is_valid() -> bool:
	if run_id.is_empty():
		return false
	for currency_id: Variant in rewards:
		if StringName(currency_id).is_empty() or int(rewards[currency_id]) <= 0:
			return false
	return completed or rewards.is_empty()
