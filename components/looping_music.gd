class_name LoopingMusic
extends AudioStreamPlayer
## Keeps a supplied Music-bus stream playing without editing its source asset.


func _ready() -> void:
	finished.connect(play)
	play()
