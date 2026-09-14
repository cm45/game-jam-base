extends UIScreen
## Small runnable landing scene for testing the app shell before game scenes exist.

@onready var _starter_button: Button = %StarterButton


func _ready() -> void:
	super()
	_starter_button.grab_focus()


func _on_starter_button_pressed() -> void:
	SceneRouter.change_to(StarterGame.HOME_SCENE)


func _on_settings_button_pressed() -> void:
	AppShell.open_menu(&"settings")


func _on_controls_button_pressed() -> void:
	AppShell.open_menu(&"controls")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
