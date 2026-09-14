class_name DemoWorldSurface
extends Node2D
## Draws the small demonstration maps directly from the supplied field tiles.
##
## This keeps the example legible without asking a first-time jammer to learn
## TileMap setup before they can explore the playable loop.

enum MapKind {
	HOME,
	RUN,
}

const TILE_SIZE := 16
const MAP_COLUMNS := 40
const MAP_ROWS := 23
const FIELD_TEXTURE := preload("res://assets/ninja_adventure/source/Backgrounds/Tilesets/TilesetField.png")
const NATURE_TEXTURE := preload("res://assets/ninja_adventure/source/Backgrounds/Tilesets/TilesetNature.png")
const CAMP_TEXTURE := preload("res://assets/ninja_adventure/source/Backgrounds/Tilesets/tileset_camp.png")
const GRASS_REGION := Rect2(16, 64, 16, 16)
const PATH_REGION := Rect2(16, 16, 16, 16)
const TREE_REGION := Rect2(0, 0, 32, 32)
const TENT_REGIONS := [Rect2(64, 0, 48, 48), Rect2(112, 0, 48, 48), Rect2(160, 0, 48, 48)]

@export var map_kind: MapKind = MapKind.HOME


func _draw() -> void:
	_draw_grass()
	if map_kind == MapKind.HOME:
		_draw_home()
	else:
		_draw_run()


func _draw_grass() -> void:
	for row in MAP_ROWS:
		for column in MAP_COLUMNS:
			_draw_field_tile(Vector2i(column, row), GRASS_REGION)


func _draw_home() -> void:
	for column in range(9, 32):
		_draw_field_tile(Vector2i(column, 14), PATH_REGION)
	for row in range(9, 22):
		_draw_field_tile(Vector2i(20, row), PATH_REGION)
	for tree_position in [Vector2(16, 212), Vector2(568, 208), Vector2(548, 52)]:
		_draw_tree(tree_position)
	_draw_tent(Vector2(72, 64), TENT_REGIONS[0])
	_draw_tent(Vector2(264, 58), TENT_REGIONS[1])
	_draw_tent(Vector2(448, 64), TENT_REGIONS[2])
	_draw_flower_patch(Rect2(42, 148, 70, 34))
	_draw_flower_patch(Rect2(488, 152, 64, 34))


func _draw_run() -> void:
	for column in range(3, 37):
		_draw_field_tile(Vector2i(column, 17), PATH_REGION)
	for row in range(4, 18):
		_draw_field_tile(Vector2i(33, row), PATH_REGION)
	for tree_position in [Vector2(20, 24), Vector2(494, 36), Vector2(42, 258), Vector2(526, 240)]:
		_draw_tree(tree_position)
	_draw_flower_patch(Rect2(154, 92, 54, 34))
	_draw_flower_patch(Rect2(286, 212, 68, 36))


func _draw_field_tile(cell: Vector2i, source_region: Rect2) -> void:
	var destination := Rect2(cell.x * TILE_SIZE, cell.y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
	draw_texture_rect_region(FIELD_TEXTURE, destination, source_region)


func _draw_tree(position_in_world: Vector2) -> void:
	draw_texture_rect_region(NATURE_TEXTURE, Rect2(position_in_world, Vector2(32, 32)), TREE_REGION)


func _draw_tent(position_in_world: Vector2, source_region: Rect2) -> void:
	draw_texture_rect_region(CAMP_TEXTURE, Rect2(position_in_world, source_region.size), source_region)


func _draw_flower_patch(rectangle: Rect2) -> void:
	draw_rect(rectangle, Color(0.25, 0.62, 0.26, 0.5))
	for point in [Vector2(6, 8), Vector2(22, 16), Vector2(41, 7), Vector2(33, 27)]:
		draw_circle(rectangle.position + point, 2.0, Color(1.0, 0.79, 0.35, 0.9))
