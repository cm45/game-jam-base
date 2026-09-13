extends Control
## Small runnable landing scene for testing the app shell before game scenes exist.

@onready var _preview_button: Button = %PreviewButton


func _ready() -> void:
	_preview_button.grab_focus()


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
