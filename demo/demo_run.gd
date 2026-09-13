extends Node2D
## A short collect-and-exit run proving permanent upgrades affect later play.

const HOME_SCENE := "res://demo/demo_home.tscn"
const LAST_RUN_KEY: StringName = &"demo_last_run"
const REQUIRED_SHARDS := 6
const BASE_GOLD_REWARD := 15
const INSIGHT_REWARD := 1

@onready var _player: TopDownPlayer = %Player
@onready var _pickup_container: Node2D = %Pickups
@onready var _exit_target: InteractionTarget = %ExitTarget
@onready var _shard_counter: Label = %ShardCounter
@onready var _run_stats: Label = %RunStats
@onready var _interaction_hint: Label = %InteractionHint
@onready var _interaction_panel: PanelContainer = %InteractionPanel
@onready var _summary: Control = %Summary
@onready var _summary_text: Label = %SummaryText
@onready var _return_button: Button = %ReturnButton
@onready var _pickup_sound: AudioStreamPlayer = %PickupSound

var _collected_shards := 0
var _run_complete := false


func _ready() -> void:
	_player.set_movement_speed(Progression.get_effective_stat(&"run_speed", _player.movement_speed))
	for pickup: ResourcePickup in _pickup_container.get_children():
		pickup.picked_up.connect(_on_pickup_collected)
	_exit_target.activated.connect(_complete_run)
	_return_button.pressed.connect(_return_to_home)
	_summary.hide()
	_interaction_panel.hide()
	_refresh_hud()


func _process(_delta: float) -> void:
	if _run_complete:
		_interaction_panel.hide()
		return
	if _exit_target.is_player_nearby():
		if _collected_shards < REQUIRED_SHARDS:
			_interaction_hint.text = "Collect %d more Sun Shard%s" % [
				REQUIRED_SHARDS - _collected_shards,
				"" if REQUIRED_SHARDS - _collected_shards == 1 else "s",
			]
		else:
			_interaction_hint.text = "[E] Leave the meadow with your rewards"
		_interaction_panel.show()
	else:
		_interaction_panel.hide()


func _on_pickup_collected(_pickup: ResourcePickup, amount: int) -> void:
	_collected_shards += amount
	if not _pickup_sound.playing:
		_pickup_sound.play()
	if _collected_shards >= REQUIRED_SHARDS:
		_exit_target.interaction_enabled = true
	_refresh_hud()


func _complete_run(_actor: Node2D) -> void:
	if _run_complete or _collected_shards < REQUIRED_SHARDS:
		return
	_run_complete = true
	_exit_target.interaction_enabled = false
	var multiplier := Progression.get_effective_stat(&"run_reward_multiplier", 1.0)
	var earned_gold := ceili(BASE_GOLD_REWARD * multiplier)
	Progression.grant_currency(&"gold", earned_gold)
	Progression.grant_currency(&"insight", INSIGHT_REWARD)
	SaveStore.set_progress(LAST_RUN_KEY, {
		"gold": earned_gold,
		"insight": INSIGHT_REWARD,
		"multiplier": multiplier,
	})
	_summary_text.text = "RUN COMPLETE\n\n%d Sun Shards recovered\n\n+%d GOLD  (base %d x %.2f)\n+%d INSIGHT\n\nReturn home to spend your rewards." % [
		_collected_shards,
		earned_gold,
		BASE_GOLD_REWARD,
		multiplier,
		INSIGHT_REWARD,
	]
	_summary.show()
	_return_button.grab_focus()


func _return_to_home() -> void:
	_pickup_sound.stop()
	SceneRouter.change_to(HOME_SCENE)


func _refresh_hud() -> void:
	_shard_counter.text = "SUN SHARDS  %d / %d" % [_collected_shards, REQUIRED_SHARDS]
	_run_stats.text = "SPD %d  x%.2f" % [
		roundi(_player.movement_speed),
		Progression.get_effective_stat(&"run_reward_multiplier", 1.0),
	]
