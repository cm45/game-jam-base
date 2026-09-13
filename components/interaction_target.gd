class_name InteractionTarget
extends Area2D
## Emits an intent when the player presses the shared interact action nearby.
##
## The scene owning this node decides what activation means. It can open a
## panel, show dialogue, change scenes, or complete a run without this
## component needing to know any of those systems.

signal activated(actor: Node2D)

const GROUP_NAME: StringName = &"interaction_targets"

@export_multiline var prompt := "Interact"
@export var interaction_enabled := true:
	set(value):
		interaction_enabled = value
		monitoring = value

var _nearby_player: Node2D


func _ready() -> void:
	add_to_group(GROUP_NAME)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	monitoring = interaction_enabled


func is_player_nearby() -> bool:
	return interaction_enabled and is_instance_valid(_nearby_player)


func _unhandled_input(event: InputEvent) -> void:
	if not interaction_enabled or not is_player_nearby():
		return
	if event.is_action_pressed(InputActions.INTERACT):
		get_viewport().set_input_as_handled()
		activated.emit(_nearby_player)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		_nearby_player = body


func _on_body_exited(body: Node2D) -> void:
	if body == _nearby_player:
		_nearby_player = null
