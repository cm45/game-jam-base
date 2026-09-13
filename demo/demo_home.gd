extends Node2D
## Walkable demo hub that owns its world interactions and overlay UI.

const RUN_SCENE := "res://demo/demo_run.tscn"
const LAST_RUN_KEY: StringName = &"demo_last_run"

@onready var _interaction_hint: Label = %InteractionHint
@onready var _message: Label = %Message
@onready var _message_panel: PanelContainer = %MessagePanel
@onready var _interaction_panel: PanelContainer = %InteractionPanel
@onready var _wallet: Label = %Wallet
@onready var _next_run_stats: Label = %NextRunStats
@onready var _progression_panel: ProgressionPanel = %ProgressionPanel
@onready var _shrine: InteractionTarget = %Shrine
@onready var _caretaker: InteractionTarget = %Caretaker
@onready var _scout: InteractionTarget = %Scout
@onready var _trader: InteractionTarget = %Trader
@onready var _run_gate: InteractionTarget = %RunGate

var _message_time_remaining := 0.0


func _ready() -> void:
	_shrine.activated.connect(_open_progression)
	_caretaker.activated.connect(_talk_to_caretaker)
	_scout.activated.connect(_talk_to_scout)
	_trader.activated.connect(_talk_to_trader)
	_run_gate.activated.connect(_start_run)
	_progression_panel.close_requested.connect(_close_progression)
	Progression.currency_changed.connect(func(_id: StringName, _amount: int) -> void: _refresh_hud())
	Progression.upgrade_purchased.connect(func(_id: StringName, _level: int) -> void: _refresh_hud())
	Progression.progression_reset.connect(_refresh_hud)
	_refresh_hud()
	_show_last_run_message()


func _process(delta: float) -> void:
	if _message_time_remaining > 0.0:
		_message_time_remaining -= delta
		if _message_time_remaining <= 0.0:
			_message_panel.hide()
	if _progression_panel.visible:
		_interaction_panel.hide()
		return
	var nearby_target := _get_nearby_target()
	if nearby_target == null:
		_interaction_panel.hide()
		return
	_interaction_hint.text = "[E] %s" % nearby_target.prompt
	_interaction_panel.show()


func _open_progression(_actor: Node2D) -> void:
	_progression_panel.show()
	_progression_panel.refresh()


func _close_progression() -> void:
	_progression_panel.hide()


func _talk_to_caretaker(_actor: Node2D) -> void:
	_show_message("Caretaker: Bring Sun Shards back from the meadow. Every run makes the shrine stronger.")


func _talk_to_scout(_actor: Node2D) -> void:
	_show_message("Scout: Pathfinder makes the next expedition quicker. The shrine tracks permanent upgrades.")


func _talk_to_trader(_actor: Node2D) -> void:
	_show_message("Trader: Gold buys upgrades. Insight unlocks the deeper paths in the shrine.")


func _start_run(_actor: Node2D) -> void:
	SceneRouter.change_to(RUN_SCENE)


func _refresh_hud() -> void:
	_wallet.text = "GOLD %d    INSIGHT %d" % [
		Progression.get_balance(&"gold"),
		Progression.get_balance(&"insight"),
	]
	_next_run_stats.text = "SPD %d  x%.2f  HP %d" % [
		roundi(Progression.get_effective_stat(&"run_speed", 72.0)),
		Progression.get_effective_stat(&"run_reward_multiplier", 1.0),
		roundi(Progression.get_effective_stat(&"starting_health", 5.0)),
	]


func _show_last_run_message() -> void:
	var saved_result: Variant = SaveStore.get_progress(LAST_RUN_KEY, {})
	if not saved_result is Dictionary or saved_result.is_empty():
		return
	_show_message("Last expedition: +%d Gold, +%d Insight." % [
		int(saved_result.get("gold", 0)),
		int(saved_result.get("insight", 0)),
	])


func _show_message(text: String) -> void:
	_message.text = text
	_message_panel.show()
	_message_time_remaining = 5.0


func _get_nearby_target() -> InteractionTarget:
	for target: InteractionTarget in get_tree().get_nodes_in_group(InteractionTarget.GROUP_NAME):
		if target.is_player_nearby():
			return target
	return null
