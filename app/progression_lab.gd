extends Control
## App-owned host for the feature-owned progression review interface.

@onready var _progression_panel: ProgressionPanel = %ProgressionPanel


func _ready() -> void:
	_progression_panel.close_requested.connect(_return_to_hub)


func _return_to_hub() -> void:
	SceneRouter.return_home()
