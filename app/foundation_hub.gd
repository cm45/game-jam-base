extends Control
## Small runnable landing scene for testing the app shell before game scenes exist.

@onready var _demo_button: Button = %DemoButton


func _ready() -> void:
	_demo_button.grab_focus()


func _on_demo_button_pressed() -> void:
	SceneRouter.change_to("res://demo/demo_home.tscn")


func _on_preview_button_pressed() -> void:
	SceneRouter.change_to("res://app/foundation_preview.tscn")


func _on_progression_button_pressed() -> void:
	SceneRouter.change_to("res://app/progression_lab.tscn")


func _on_settings_button_pressed() -> void:
	AppShell.open_menu(&"settings")


func _on_controls_button_pressed() -> void:
	AppShell.open_menu(&"controls")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
