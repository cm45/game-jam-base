extends Control
## Keeps the Milestone 1 preview as a second scene for router verification.

@onready var _back_button: Button = %BackButton


func _ready() -> void:
	_back_button.grab_focus()


func _on_back_button_pressed() -> void:
	SceneRouter.return_to_foundation_hub()
