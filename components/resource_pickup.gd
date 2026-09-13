class_name ResourcePickup
extends Area2D
## A one-shot collectable that reports its value to the owning scene.

signal picked_up(pickup: ResourcePickup, amount: int)

const GROUP_NAME: StringName = &"resource_pickups"

@export_range(1, 999, 1) var amount := 1

var _collected := false


func _ready() -> void:
	add_to_group(GROUP_NAME)
	body_entered.connect(_on_body_entered)


func collect() -> void:
	if _collected:
		return
	_collected = true
	monitoring = false
	picked_up.emit(self, amount)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		collect()
