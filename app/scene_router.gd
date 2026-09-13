extends Node
## Provides explicit scene changes without coupling menus to game scenes.

signal scene_change_started(scene_path: String)
signal scene_changed(scene_path: String)

const FOUNDATION_HUB_SCENE := "res://app/foundation_hub.tscn"

var _is_changing_scene := false


func change_to(scene_path: String) -> Error:
	if _is_changing_scene:
		return ERR_BUSY
	if not ResourceLoader.exists(scene_path):
		push_error("Cannot change to missing scene: %s" % scene_path)
		return ERR_FILE_NOT_FOUND
	_is_changing_scene = true
	get_tree().paused = false
	scene_change_started.emit(scene_path)
	var result := get_tree().change_scene_to_file(scene_path)
	if result == OK:
		scene_changed.emit(scene_path)
	_is_changing_scene = false
	return result


func return_to_foundation_hub() -> Error:
	return change_to(FOUNDATION_HUB_SCENE)
