extends Node2D
## Small collect-and-exit run showing one complete RunContext → RunResult route.

const REQUIRED_TOKENS := 3
const BASE_GOLD_REWARD := 8
const INSIGHT_REWARD := 1

@onready var _player: TopDownPlayer = %Player
@onready var _pickups: Node2D = %Pickups
@onready var _exit_target: InteractionTarget = %ExitTarget
@onready var _token_counter: Label = %TokenCounter
@onready var _run_stats: Label = %RunStats
@onready var _interaction_panel: PanelContainer = %InteractionPanel
@onready var _interaction_hint: Label = %InteractionHint
@onready var _summary: Control = %Summary
@onready var _summary_text: Label = %SummaryText
@onready var _claim_button: Button = %ClaimButton
@onready var _pickup_sound: AudioStreamPlayer = %PickupSound
@onready var _reward_sound: AudioStreamPlayer = %RewardSound

var _context: RunContext
var _collected_tokens := 0
var _completion_ready := false


func _ready() -> void:
	_context = _get_or_create_context()
	_player.set_movement_speed(float(_context.get_starting_value(&"move_speed", GameDefinition.BASE_MOVE_SPEED)))
	for pickup: ResourcePickup in _pickups.get_children():
		pickup.picked_up.connect(_on_pickup_collected)
		pickup.set_pickup_radius(float(_context.get_starting_value(&"pickup_radius", 7.0)))
	_exit_target.activated.connect(_prepare_completion)
	_claim_button.pressed.connect(_claim_and_return_home)
	_exit_target.interaction_enabled = false
	_interaction_panel.hide()
	_summary.hide()
	_refresh_hud()


func _process(_delta: float) -> void:
	if _completion_ready:
		_interaction_panel.hide()
		return
	if not _exit_target.is_player_nearby():
		_interaction_panel.hide()
		return
	_interaction_hint.text = "[E] Return home with your reward"
	_interaction_panel.show()


func _on_pickup_collected(_pickup: ResourcePickup, amount: int) -> void:
	if _completion_ready:
		return
	_collected_tokens += amount
	_pickup_sound.play()
	if _collected_tokens >= REQUIRED_TOKENS:
		_exit_target.interaction_enabled = true
	_refresh_hud()


func _prepare_completion(_actor: Node2D) -> void:
	if _completion_ready or _collected_tokens < REQUIRED_TOKENS:
		return
	_completion_ready = true
	_reward_sound.play()
	_exit_target.interaction_enabled = false
	var earned_gold := _earned_gold()
	_summary_text.text = "RUN COMPLETE\n\n%d expedition tokens recovered\n\n+%d GOLD\n+%d INSIGHT\n\nClaim these rewards at home." % [
		_collected_tokens,
		earned_gold,
		_earned_insight(),
	]
	# Freeze this world locally; closing the global pause menu must not resume it.
	process_mode = Node.PROCESS_MODE_DISABLED
	_summary.process_mode = Node.PROCESS_MODE_ALWAYS
	_reward_sound.process_mode = Node.PROCESS_MODE_ALWAYS
	_summary.show()
	_claim_button.grab_focus()


func _claim_and_return_home() -> void:
	var result := RunResult.new(
		_context.run_id,
		true,
		{&"gold": _earned_gold(), &"insight": _earned_insight()},
		"+%d Gold, +%d Insight" % [_earned_gold(), _earned_insight()],
		{&"tokens": _collected_tokens},
	)
	if RunSession.complete_run(result) != OK:
		_summary_text.text = "Could not claim rewards. Check the RunResult contract."
		return
	SceneRouter.change_to(_context.return_scene_path)


func _refresh_hud() -> void:
	_token_counter.text = "TOKENS  %d / %d" % [_collected_tokens, REQUIRED_TOKENS]
	_run_stats.text = "SPD %d  x%.2f" % [
		roundi(_player.movement_speed),
		float(_context.get_starting_value(&"reward_multiplier", GameDefinition.BASE_REWARD_MULTIPLIER)),
	]


func _earned_gold() -> int:
	return ceili((BASE_GOLD_REWARD + float(_context.get_starting_value(&"bonus_gold", 0.0))) * float(_context.get_starting_value(
		&"reward_multiplier",
		GameDefinition.BASE_REWARD_MULTIPLIER,
	)))


func _get_or_create_context() -> RunContext:
	var context := RunSession.get_active_context()
	if context != null and context.run_id == GameDefinition.RUN_ID:
		return context
	var fallback_context := GameDefinition.create_run_context()
	RunSession.begin_run(fallback_context)
	return fallback_context


func _earned_insight() -> int:
	return maxi(1, roundi(float(_context.get_starting_value(&"insight_reward", 1.0))))
