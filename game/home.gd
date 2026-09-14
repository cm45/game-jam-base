extends Node2D
## Walkable camp hub that demonstrates separate shop, skill, and run stations.

@onready var _shop_window: ProgressionPanel = %ShopWindow
@onready var _skill_window: ProgressionPanel = %SkillTreeWindow
@onready var _merchant: InteractionTarget = %Merchant
@onready var _mentor: InteractionTarget = %Mentor
@onready var _scout: InteractionTarget = %Scout
@onready var _wallet: Label = %Wallet
@onready var _run_preview: Label = %RunPreview
@onready var _interaction_panel: PanelContainer = %InteractionPanel
@onready var _interaction_hint: Label = %InteractionHint
@onready var _message_panel: PanelContainer = %MessagePanel
@onready var _message: Label = %Message

var _message_time_remaining := 0.0


func _ready() -> void:
	_merchant.activated.connect(_open_shop)
	_mentor.activated.connect(_open_skill_tree)
	_scout.activated.connect(_start_run)
	_shop_window.close_requested.connect(_shop_window.hide)
	_skill_window.close_requested.connect(_skill_window.hide)
	Progression.currency_changed.connect(func(_id: StringName, _amount: int) -> void: _refresh_hud())
	Progression.upgrade_purchased.connect(func(_id: StringName, _level: int) -> void: _refresh_hud())
	Progression.progression_reset.connect(_refresh_hud)
	_refresh_hud()
	_show_last_result()


func _process(delta: float) -> void:
	if _message_time_remaining > 0.0:
		_message_time_remaining -= delta
		if _message_time_remaining <= 0.0:
			_message_panel.hide()
	if _shop_window.visible or _skill_window.visible:
		_interaction_panel.hide()
		return
	var nearby_target := _get_nearby_target()
	if nearby_target == null:
		_interaction_panel.hide()
		return
	_interaction_hint.text = "[E] %s" % nearby_target.prompt
	_interaction_panel.show()


func _open_shop(_actor: Node2D) -> void:
	_skill_window.hide()
	_shop_window.show()
	_shop_window.refresh()


func _open_skill_tree(_actor: Node2D) -> void:
	_shop_window.hide()
	_skill_window.show()
	_skill_window.refresh()


func _start_run(_actor: Node2D) -> void:
	var context := GameDefinition.create_run_context()
	if RunSession.begin_run(context) != OK:
		_show_message("The expedition could not start. Check the RunContext paths.")
		return
	if SceneRouter.change_to(context.run_scene_path) != OK:
		RunSession.abandon_active_run()
		_show_message("The run scene could not be opened.")


func _refresh_hud() -> void:
	$Player.set_movement_speed(Progression.get_effective_stat(&"run_speed", GameDefinition.BASE_MOVE_SPEED))
	_wallet.text = "GOLD %d  •  INSIGHT %d" % [
		Progression.get_balance(&"gold"),
		Progression.get_balance(&"insight"),
	]
	_run_preview.text = "NEXT RUN  SPD %d  ×%.2f" % [
		roundi(Progression.get_effective_stat(&"run_speed", GameDefinition.BASE_MOVE_SPEED)),
		Progression.get_effective_stat(&"run_reward_multiplier", GameDefinition.BASE_REWARD_MULTIPLIER),
	]


func _show_last_result() -> void:
	var result := RunSession.get_last_result()
	if result == null or not result.completed:
		return
	_show_message("Last run: %s" % result.summary)


func _show_message(text: String) -> void:
	_message.text = text
	_message_panel.show()
	_message_time_remaining = 5.0


func _get_nearby_target() -> InteractionTarget:
	for target: InteractionTarget in get_tree().get_nodes_in_group(InteractionTarget.GROUP_NAME):
		if target.is_player_nearby():
			return target
	return null
