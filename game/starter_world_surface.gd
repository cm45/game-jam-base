extends Node2D
## Small draw-only environment for the starter scenes.
##
## It only draws the grass and paths. Camp props live as editable scene nodes
## in `starter_home.tscn`, so a participant can remove or rearrange them.

enum MapKind { HOME, RUN }

const TILE_SIZE := 16
const MAP_COLUMNS := 40
const MAP_ROWS := 22
const FIELD_TEXTURE := preload("res://assets/ninja_adventure/source/Backgrounds/Tilesets/TilesetField.png")
const GRASS_REGION := Rect2(16, 64, TILE_SIZE, TILE_SIZE)
const PATH_REGION := Rect2(16, 16, TILE_SIZE, TILE_SIZE)

@export var map_kind: MapKind = MapKind.HOME


func _draw() -> void:
	_draw_grass_field()
	if map_kind == MapKind.HOME:
		_draw_home_landmarks()
	else:
		_draw_run_landmarks()


func _draw_grass_field() -> void:
	for row in MAP_ROWS:
		for column in MAP_COLUMNS:
			_draw_tile(Vector2i(column, row), GRASS_REGION)


func _draw_home_landmarks() -> void:
	for column in range(4, 37):
		_draw_tile(Vector2i(column, 15), PATH_REGION)
	for row in range(7, 16):
		_draw_tile(Vector2i(18, row), PATH_REGION)
		_draw_tile(Vector2i(28, row), PATH_REGION)
	for column in range(18, 29):
		_draw_tile(Vector2i(column, 8), PATH_REGION)


func _draw_run_landmarks() -> void:
	for column in range(3, 37):
		_draw_tile(Vector2i(column, 16), PATH_REGION)
	for row in range(5, 17):
		_draw_tile(Vector2i(34, row), PATH_REGION)


func _draw_tile(cell: Vector2i, source_region: Rect2) -> void:
	draw_texture_rect_region(
		FIELD_TEXTURE,
		Rect2(Vector2(cell * TILE_SIZE), Vector2(TILE_SIZE, TILE_SIZE)),
		source_region,
	)
