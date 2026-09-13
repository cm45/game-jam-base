extends Node
## Registers the small, project-wide input vocabulary used by the foundation.
##
## Individual games can add actions in Project Settings without changing this
## service. Existing bindings are preserved so a future rebinding system can
## replace these defaults.

const MOVE_UP: StringName = &"move_up"
const MOVE_DOWN: StringName = &"move_down"
const MOVE_LEFT: StringName = &"move_left"
const MOVE_RIGHT: StringName = &"move_right"
const INTERACT: StringName = &"interact"
const PAUSE: StringName = &"pause"
const CONFIRM: StringName = &"confirm"
const CANCEL: StringName = &"cancel"


func _ready() -> void:
	_register_defaults()


func get_binding_text(action: StringName) -> String:
	var labels: PackedStringArray = []
	for event: InputEvent in InputMap.action_get_events(action):
		labels.append(event.as_text())
	return ", ".join(labels)


func _register_defaults() -> void:
	_register_keys(MOVE_UP, [KEY_W, KEY_UP])
	_register_keys(MOVE_DOWN, [KEY_S, KEY_DOWN])
	_register_keys(MOVE_LEFT, [KEY_A, KEY_LEFT])
	_register_keys(MOVE_RIGHT, [KEY_D, KEY_RIGHT])
	_register_keys(INTERACT, [KEY_E])
	_register_keys(PAUSE, [KEY_ESCAPE])
	_register_keys(CONFIRM, [KEY_ENTER, KEY_SPACE])
	_register_keys(CANCEL, [KEY_ESCAPE])


func _register_keys(action: StringName, keys: Array[Key]) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	if not InputMap.action_get_events(action).is_empty():
		return
	for key: Key in keys:
		var event := InputEventKey.new()
		event.keycode = key
		InputMap.action_add_event(action, event)
