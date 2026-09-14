extends CanvasLayer
## Persistent UI entry point that owns the pause menu across scene changes.

const PAUSE_MENU_SCENE := preload("res://ui/pause_menu/pause_menu.tscn")
const UI_CLICK_STREAM_PATH := "res://assets/ninja_adventure/source/Audio/Sounds/Menu/Accept.wav"

var _pause_menu: PauseMenu
var _ui_click: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	_ui_click = AudioStreamPlayer.new()
	# Loading after startup lets a brand-new clone finish importing the WAV first.
	_ui_click.stream = load(UI_CLICK_STREAM_PATH) as AudioStream
	_ui_click.bus = &"SFX"
	_ui_click.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_ui_click)
	_pause_menu = PAUSE_MENU_SCENE.instantiate()
	add_child(_pause_menu)
	SceneRouter.scene_change_started.connect(_on_scene_change_started)
	SceneRouter.scene_changed.connect(_on_scene_changed)
	_connect_button_sounds(_pause_menu)
	call_deferred("_connect_current_scene_button_sounds")


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


func _on_scene_changed(_scene_path: String) -> void:
	call_deferred("_connect_current_scene_button_sounds")


func _connect_current_scene_button_sounds() -> void:
	_connect_button_sounds(get_tree().current_scene)


func _connect_button_sounds(root: Node) -> void:
	if root == null:
		return
	for node: Node in root.find_children("*", "BaseButton", true, false):
		var button := node as BaseButton
		if button != null and not button.pressed.is_connected(_play_ui_click):
			button.pressed.connect(_play_ui_click)


func _play_ui_click() -> void:
	if _ui_click.stream != null:
		_ui_click.play()
