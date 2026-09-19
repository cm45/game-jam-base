class_name TopDownPlayer
extends CharacterBody2D
## A small keyboard-driven character for top-down prototype scenes.
##
## The component only knows how to move and animate. A run scene can set its
## speed from a progression effect, while another game can use a fixed value.

@export var movement_speed := 72.0
@export var world_bounds := Rect2(12.0, 12.0, 616.0, 336.0)

@onready var _sprite: Sprite2D = $Sprite

var _facing_row := 0
var _walk_frame := 0
var _walk_timer := 0.0
var _facing_col := 0


func set_movement_speed(new_speed: float) -> void:
	movement_speed = maxf(new_speed, 1.0)


func _ready() -> void:
	add_to_group(&"player")
	_update_sprite(Vector2.DOWN)


func _physics_process(delta: float) -> void:
	var movement := Input.get_vector(
		InputActions.MOVE_LEFT,
		InputActions.MOVE_RIGHT,
		InputActions.MOVE_UP,
		InputActions.MOVE_DOWN,
	)
	velocity = movement * movement_speed
	move_and_slide()
	global_position = global_position.clamp(world_bounds.position, world_bounds.end)
	_update_sprite(movement)
	if not movement.is_zero_approx():
		_walk_timer += delta
		if _walk_timer >= 0.12:
			_walk_timer = 0.0
			_walk_frame = (_walk_frame + 4) % 16
	else:
		_walk_timer = 0.0
		_walk_frame = 0
	_sprite.frame = _facing_col + _walk_frame


func _update_sprite(movement: Vector2) -> void:
	if movement.is_zero_approx():
		_facing_col = 0
		return
	if absf(movement.x) > absf(movement.y):
		_facing_col = 3 if movement.x > 0.0 else 2
	else:
		_facing_col = 1 if movement.y < 0.0 else 0
