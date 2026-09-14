extends Node
## Exercises real slider wiring and the upgraded starter reward/stop behavior.

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	SaveStore.use_temporary_storage(&"camp_runtime")
	SaveStore.reset_all()
	Progression.load_progress()
	var pause := AppShell.get_child(AppShell.get_child_count() - 1) as PauseMenu
	for slider_name: String in ["MasterSlider", "MusicSlider", "SfxSlider"]:
		var slider := pause.find_child(slider_name, true, false) as HSlider
		assert(slider.max_value == 1.0 and slider.step == 0.01)
		var bus_name := &"Master" if slider_name == "MasterSlider" else (&"Music" if slider_name == "MusicSlider" else &"SFX")
		var bus := AudioServer.get_bus_index(bus_name)
		slider.value = 1.0
		assert(is_equal_approx(AudioServer.get_bus_volume_db(bus), 0.0))
		slider.value = 0.1
		assert(is_equal_approx(AudioServer.get_bus_volume_db(bus), -40.0))
		slider.value = 0.01
		assert(is_equal_approx(AudioServer.get_bus_volume_db(bus), -80.0))
		slider.value = 0.0
		assert(AudioServer.is_bus_mute(bus))
	Progression.grant_currency(&"gold", 1000)
	Progression.grant_currency(&"insight", 1000)
	for upgrade: UpgradeDefinition in Progression.CATALOG.shop_upgrades:
		assert(Progression.try_purchase_shop(upgrade.id).success)
	for skill: UpgradeDefinition in Progression.CATALOG.skill_nodes:
		assert(Progression.try_unlock_skill(skill.id).success)
	var context := StarterGame.create_run_context()
	assert(context.get_starting_value(&"move_speed", 0.0) == 192.0)
	assert(context.get_starting_value(&"pickup_radius", 0.0) == 51.0)
	assert(context.get_starting_value(&"bonus_gold", 0.0) == 5.0)
	assert(context.get_starting_value(&"insight_reward", 0.0) == 4.0)
	RunSession.begin_run(context)
	var run := (load("res://game/starter_run.tscn") as PackedScene).instantiate()
	add_child(run)
	await get_tree().process_frame
	var player := run.get_node("Player") as TopDownPlayer
	assert(player.movement_speed == 192.0)
	for pickup: ResourcePickup in run.get_node("Pickups").get_children():
		assert((pickup.get_node("CollisionShape2D").shape as CircleShape2D).radius == 51.0)
		pickup.collect()
	await get_tree().process_frame
	run.get_node("ExitTarget").activated.emit(player)
	assert(run.process_mode == Node.PROCESS_MODE_DISABLED)
	assert(run.get_node("Interface/HUD/Summary").can_process())
	assert(not player.can_process())
	assert(run.call("_earned_gold") == 40)
	assert(run.call("_earned_insight") == 4)
	AppShell.open_menu()
	AppShell.close_menu()
	assert(not player.can_process())
	run.queue_free()
	await get_tree().process_frame
	RunSession.abandon_active_run()
	SaveStore.restore_default_storage()
	Progression.load_progress()
	AudioSettings.load_and_apply()
	print("camp_runtime_smoke: PASS")
	get_tree().quit()
