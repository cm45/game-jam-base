class_name RunContext
extends RefCounted
## Read-only input a home scene prepares before it starts one specific run.
##
## Keep genre-specific values in `starting_values` or `payload`. The run reads
## them but does not write permanent progression through this object.

var run_id: StringName
var run_scene_path := ""
var return_scene_path := ""
var display_name := ""
var starting_values: Dictionary = {}
var payload: Dictionary = {}


func _init(
		id: StringName = &"",
		scene_path := "",
		home_path := "",
		name := "",
		values: Dictionary = {},
		data: Dictionary = {},
	) -> void:
	run_id = id
	run_scene_path = scene_path
	return_scene_path = home_path
	display_name = name
	starting_values = values.duplicate(true)
	payload = data.duplicate(true)


func is_valid() -> bool:
	return not run_id.is_empty() \
		and not run_scene_path.is_empty() \
		and not return_scene_path.is_empty() \
		and ResourceLoader.exists(run_scene_path) \
		and ResourceLoader.exists(return_scene_path)


func get_starting_value(value_id: StringName, fallback: Variant = null) -> Variant:
	return starting_values.get(value_id, fallback)
