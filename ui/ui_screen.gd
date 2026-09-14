class_name UIScreen
extends Control
## Hosts full-screen interface at a readable desktop design size.
##
## The game world keeps its 640×360 pixel grid. Full-screen menus instead lay
## themselves out at 1280×720, then scale down into that grid. The window's
## normal stretch setting enlarges both layers together without making desktop
## controls occupy the entire display.

@export var design_size := Vector2(1280.0, 720.0)
@export_range(0.1, 1.0, 0.05) var canvas_scale := 0.5


func _ready() -> void:

	_apply_design_size()


func _apply_design_size() -> void:

	set_anchors_preset(Control.PRESET_TOP_LEFT)
	position = Vector2.ZERO
	size = design_size
	scale = Vector2.ONE * canvas_scale
