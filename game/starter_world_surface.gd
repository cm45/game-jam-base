extends Node2D
## Small draw-only environment for the starter scenes.
##
## It uses full center tiles from Ninja Adventure's atlases. Replace this node
## when a participant brings in a TileMap, procedural map, or custom art.

enum MapKind { HOME, RUN }

const TILE_SIZE := 16
const MAP_COLUMNS := 40
const MAP_ROWS := 22
const FIELD_TEXTURE := preload("res://assets/ninja_adventure/source/Backgrounds/Tilesets/TilesetField.png")
const NATURE_TEXTURE := preload("res://assets/ninja_adventure/source/Backgrounds/Tilesets/TilesetNature.png")
const CAMP_TEXTURE := preload("res://assets/ninja_adventure/source/Backgrounds/Tilesets/tileset_camp.png")
const GRASS_REGION := Rect2(16, 64, TILE_SIZE, TILE_SIZE)
const PATH_REGION := Rect2(16, 16, TILE_SIZE, TILE_SIZE)
const TREE_REGION := Rect2(0, 0, 32, 48)
const TENT_REGION := Rect2(64, 0, 48, 48)

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
	for column in range(5, 35):
		_draw_tile(Vector2i(column, 13), PATH_REGION)
	for row in range(10, 14):
		_draw_tile(Vector2i(25, row), PATH_REGION)
	draw_texture_rect_region(CAMP_TEXTURE, Rect2(Vector2(72, 104), Vector2(48, 48)), TENT_REGION)
	_draw_tree(Vector2(20, 72))
	_draw_tree(Vector2(560, 60))
	_draw_tree(Vector2(520, 272))


func _draw_run_landmarks() -> void:
	for column in range(3, 37):
		_draw_tile(Vector2i(column, 16), PATH_REGION)
	for row in range(5, 17):
		_draw_tile(Vector2i(34, row), PATH_REGION)
	_draw_tree(Vector2(32, 56))
	_draw_tree(Vector2(534, 84))
	_draw_tree(Vector2(102, 264))


func _draw_tile(cell: Vector2i, source_region: Rect2) -> void:
	draw_texture_rect_region(
		FIELD_TEXTURE,
		Rect2(Vector2(cell * TILE_SIZE), Vector2(TILE_SIZE, TILE_SIZE)),
		source_region,
	)


func _draw_tree(position_in_world: Vector2) -> void:
	draw_texture_rect_region(NATURE_TEXTURE, Rect2(position_in_world, Vector2(32, 48)), TREE_REGION)
