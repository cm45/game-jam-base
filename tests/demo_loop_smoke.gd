extends Node
## Focused headless check for the milestone 4 collect-and-exit transaction.
## It uses a temporary SaveStore file, so it is safe to run during development.

const RUN_SCENE := preload("res://demo/demo_run.tscn")
const HOME_SCENE_PATH := "res://demo/demo_home.tscn"
func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_backup_save()
	SaveStore.reset_all()
	Progression.load_progress()
	if not _require(Progression.grant_currency(&"gold", 15), "Could not grant setup currency."):
		return
	var purchase := Progression.try_purchase(&"lucky_satchel")
	if not _require(bool(purchase.get("success", false)), "Lucky Satchel should be purchasable for the smoke test."):
		return

	var run := RUN_SCENE.instantiate()
	add_child(run)
	await get_tree().process_frame
	var pickup_sound: AudioStreamPlayer = run.get_node("PickupSound")
	pickup_sound.stream = null
	if not _require(run.get_node("Pickups").get_child_count() == 6, "Run should start with six pickups."):
		return
	var player: Node2D = run.get_node("Player")
	for pickup: ResourcePickup in run.get_node("Pickups").get_children():
		pickup.body_entered.emit(player)
	await get_tree().process_frame
	var exit_target: InteractionTarget = run.get_node("ExitTarget")
	if not _require(exit_target.interaction_enabled, "Exit should enable after every pickup."):
		return
	exit_target.body_entered.emit(player)
	var interact_event := InputEventAction.new()
	interact_event.action = InputActions.INTERACT
	interact_event.pressed = true
	exit_target._unhandled_input(interact_event)
	await get_tree().process_frame
	if not _require(Progression.get_balance(&"gold") == 18, "Lucky Satchel should raise the 15 Gold reward to 18."):
		return
	if not _require(Progression.get_balance(&"insight") == 1, "Completed run should award one Insight."):
		return
	if not _require(run.get_node("Interface/HUD/Summary").visible, "Run summary should appear after exit activation."):
		return
	if not _require(ResourceLoader.exists(HOME_SCENE_PATH), "Demo home route should exist."):
		return
	run.queue_free()
	await get_tree().process_frame
	_restore_save()
	await get_tree().process_frame
	print("demo_loop_smoke: PASS")
	get_tree().quit(0)


func _require(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error("demo_loop_smoke: %s" % message)
	_restore_save()
	get_tree().quit(1)
	return false


func _backup_save() -> void:
	SaveStore.use_temporary_storage(&"demo_loop")
	Progression.load_progress()


func _restore_save() -> void:
	SaveStore.restore_default_storage()
	Progression.load_progress()
