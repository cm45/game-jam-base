extends CanvasLayer
## Persistent UI entry point that owns the pause menu across scene changes.

const PAUSE_MENU_SCENE := preload("res://ui/pause_menu/pause_menu.tscn")

var _pause_menu: PauseMenu


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_pause_menu = PAUSE_MENU_SCENE.instantiate()
	add_child(_pause_menu)
	SceneRouter.scene_change_started.connect(_on_scene_change_started)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.PAUSE):
		get_viewport().set_input_as_handled()
		if _pause_menu.is_open():
			_pause_menu.close_menu()
		else:
			_pause_menu.open_menu()


func open_menu(page: StringName = &"main") -> void:
	_pause_menu.open_menu(page)


func close_menu() -> void:
	_pause_menu.close_menu()


func _on_scene_change_started(_scene_path: String) -> void:
	close_menu()
