extends Node
## Owns persistent volumes for the shared Master, Music, and SFX buses.

signal volume_changed(bus_name: StringName, linear_volume: float)

const MASTER_BUS: StringName = &"Master"
const MUSIC_BUS: StringName = &"Music"
const SFX_BUS: StringName = &"SFX"
const DEFAULT_BUS_LAYOUT := preload("res://features/audio/default_bus_layout.tres")

const DEFAULT_VOLUMES := {
	MASTER_BUS: 0.8,
	MUSIC_BUS: 0.65,
	SFX_BUS: 0.75,
}


func _ready() -> void:
	AudioServer.set_bus_layout(DEFAULT_BUS_LAYOUT)
	call_deferred("load_and_apply")


func load_and_apply() -> void:
	for bus_name: StringName in DEFAULT_VOLUMES:
		var fallback: float = DEFAULT_VOLUMES[bus_name]
		var saved_value: Variant = SaveStore.get_setting(_setting_key(bus_name), fallback)
		set_volume(bus_name, float(saved_value), false)


func get_volume(bus_name: StringName) -> float:
	var fallback: float = DEFAULT_VOLUMES.get(bus_name, 1.0)
	return float(SaveStore.get_setting(_setting_key(bus_name), fallback))


func set_volume(bus_name: StringName, linear_volume: float, persist := true) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		push_error("Audio bus '%s' is not defined in the default bus layout." % bus_name)
		return
	var clamped_volume := clampf(linear_volume, 0.0, 1.0)
	AudioServer.set_bus_mute(bus_index, is_zero_approx(clamped_volume))
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(clamped_volume, 0.001)))
	if persist:
		SaveStore.set_setting(_setting_key(bus_name), clamped_volume)
	volume_changed.emit(bus_name, clamped_volume)


func restore_defaults() -> void:
	for bus_name: StringName in DEFAULT_VOLUMES:
		set_volume(bus_name, DEFAULT_VOLUMES[bus_name])


func _setting_key(bus_name: StringName) -> StringName:
	return StringName("audio_%s" % String(bus_name).to_lower())
