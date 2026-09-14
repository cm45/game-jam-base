class_name ProgressionPanel
extends UIScreen
## Feature-owned presentation for separate Gold shop and Insight skill systems.

signal close_requested

const SHOP_ITEM_SCENE := preload("res://features/progression/ui/upgrade_shop_item.tscn")
enum WindowMode { LAB, SHOP, SKILLS }

@export var window_mode: WindowMode = WindowMode.LAB
@export var show_sandbox_tools := true
@export var close_button_text := "BACK TO CAMP"

var _selected_upgrade_id: StringName

@onready var _wallet: HBoxContainer = %Wallet
@onready var _shop_list: VBoxContainer = %ShopList
@onready var _tree: ProgressionTree = %ProgressionTree
@onready var _selected_kind: Label = %SelectedKind
@onready var _selected_title: Label = %SelectedTitle
@onready var _selected_description: Label = %SelectedDescription
@onready var _selected_level: Label = %SelectedLevel
@onready var _selected_effects: Label = %SelectedEffects
@onready var _selected_cost: Label = %SelectedCost
@onready var _purchase_button: Button = %PurchaseButton
@onready var _purchase_notice: Label = %PurchaseNotice
@onready var _purchase_sound: AudioStreamPlayer = %PurchaseSound


func _ready() -> void:
	super()
	_tree.upgrade_selected.connect(select_upgrade)
	%CloseButton.pressed.connect(func() -> void: close_requested.emit())
	%CloseButton.text = close_button_text
	%SandboxRow.visible = show_sandbox_tools
	%GrantGoldButton.pressed.connect(func() -> void: Progression.grant_currency(&"gold", 25))
	%GrantInsightButton.pressed.connect(func() -> void: Progression.grant_currency(&"insight", 1))
	%ZoomInButton.pressed.connect(_tree.zoom_in)
	%ZoomOutButton.pressed.connect(_tree.zoom_out)
	%FitTreeButton.pressed.connect(_tree.fit_to_tree)
	_purchase_button.pressed.connect(_purchase_selected_upgrade)
	Progression.currency_changed.connect(func(_id: StringName, _amount: int) -> void: refresh())
	Progression.shop_purchased.connect(func(_id: StringName, _level: int) -> void: refresh())
	Progression.skill_unlocked.connect(func(_id: StringName, _level: int) -> void: refresh())
	Progression.progression_reset.connect(refresh)
	_build_shop()
	if not Progression.CATALOG.shop_upgrades.is_empty():
		select_upgrade(Progression.CATALOG.shop_upgrades[0].id)
	refresh()
	if window_mode != WindowMode.LAB:
		%Views.tabs_visible = false
		%Views.set_tab_disabled(1 if window_mode == WindowMode.SHOP else 0, true)
		if window_mode == WindowMode.SHOP:
			show_shop()
		else:
			show_skill_tree()


func select_upgrade(upgrade_id: StringName) -> void:
	if window_mode == WindowMode.SHOP and not Progression.CATALOG.is_shop_upgrade(upgrade_id):
		return
	if window_mode == WindowMode.SKILLS and not Progression.CATALOG.is_skill_node(upgrade_id):
		return
	if Progression.CATALOG.get_upgrade(upgrade_id) == null:
		return
	_selected_upgrade_id = upgrade_id
	_purchase_notice.text = ""
	refresh()


func show_shop() -> void:
	if window_mode == WindowMode.SKILLS:
		return
	%Title.text = "SHOP"
	%Views.current_tab = 0
	if not Progression.CATALOG.shop_upgrades.is_empty():
		select_upgrade(Progression.CATALOG.shop_upgrades[0].id)


func show_skill_tree() -> void:
	if window_mode == WindowMode.SHOP:
		return
	%Title.text = "SKILL TREE"
	%Views.current_tab = 1
	if not Progression.CATALOG.skill_nodes.is_empty():
		select_upgrade(Progression.CATALOG.skill_nodes[0].id)


func refresh() -> void:
	if not is_node_ready():
		return
	_refresh_wallet()
	_tree.refresh()
	for child: Node in _shop_list.get_children():
		if child is UpgradeShopItem:
			child.refresh()
	_refresh_selected_upgrade()


func _build_shop() -> void:
	for child: Node in _shop_list.get_children():
		child.queue_free()
	for upgrade: UpgradeDefinition in Progression.CATALOG.shop_upgrades:
		var item: UpgradeShopItem = SHOP_ITEM_SCENE.instantiate()
		item.set_upgrade(upgrade)
		item.selected.connect(select_upgrade)
		_shop_list.add_child(item)


func _refresh_wallet() -> void:
	for child: Node in _wallet.get_children():
		child.queue_free()
	for currency: CurrencyDefinition in Progression.CATALOG.currencies:
		var label := Label.new()
		label.text = "%s: %d" % [currency.display_name, Progression.get_balance(currency.id)]
		label.add_theme_color_override("font_color", currency.display_color)
		label.add_theme_font_size_override("font_size", 17)
		_wallet.add_child(label)


func _refresh_selected_upgrade() -> void:
	var upgrade := Progression.CATALOG.get_upgrade(_selected_upgrade_id)
	if upgrade == null:
		return
	var is_shop_upgrade := Progression.CATALOG.is_shop_upgrade(upgrade.id)
	var level := Progression.get_upgrade_level(upgrade.id)
	_selected_kind.text = "SHOP IMPROVEMENT · GOLD" if is_shop_upgrade else "SKILL NODE · INSIGHT"
	_selected_title.text = upgrade.display_name
	_selected_description.text = upgrade.description
	_selected_level.text = "LEVEL %d / %d" % [level, upgrade.max_level]
	_selected_effects.text = _format_effects(upgrade)
	_selected_cost.text = _format_cost(Progression.get_upgrade_cost(upgrade.id))
	_purchase_button.disabled = not Progression.can_purchase(upgrade.id)
	if level >= upgrade.max_level:
		_purchase_button.text = "COMPLETE"
		_purchase_notice.text = "This improvement is complete."
	elif is_shop_upgrade:
		_purchase_button.text = "BUY WITH GOLD"
		if _purchase_notice.text.is_empty():
			_purchase_notice.text = "Shop improvements have no skill prerequisites."
	else:
		_purchase_button.text = "UNLOCK WITH INSIGHT"
		if not Progression.get_unmet_requirements(upgrade.id).is_empty():
			_purchase_notice.text = "Requires: %s" % _format_requirements(upgrade)
		elif _purchase_notice.text.is_empty():
			_purchase_notice.text = "Skill nodes require Insight and earlier skills."
	if not Progression.can_purchase(upgrade.id) and level < upgrade.max_level and _purchase_notice.text.is_empty():
		_purchase_notice.text = "Earn more permanent currency in a run."


func _purchase_selected_upgrade() -> void:
	if Progression.CATALOG.is_shop_upgrade(_selected_upgrade_id):
		var shop_result := Progression.try_purchase_shop(_selected_upgrade_id)
		_purchase_notice.text = String(shop_result.get("message", "Purchase failed."))
		if bool(shop_result.get("success", false)):
			_purchase_sound.play()
	else:
		var skill_result := Progression.try_unlock_skill(_selected_upgrade_id)
		_purchase_notice.text = String(skill_result.get("message", "Unlock failed."))
		if bool(skill_result.get("success", false)):
			_purchase_sound.play()
	refresh()


func _format_cost(cost: Dictionary[StringName, int]) -> String:
	if cost.is_empty():
		return "COST: COMPLETE"
	var parts: PackedStringArray = []
	for currency_id: StringName in cost:
		var currency := Progression.CATALOG.get_currency(currency_id)
		parts.append("%d %s" % [cost[currency_id], currency.display_name])
	return "COST: " + " · ".join(parts)


func _format_requirements(upgrade: UpgradeDefinition) -> String:
	var parts: PackedStringArray = []
	for requirement: UpgradeRequirement in Progression.get_unmet_requirements(upgrade.id):
		var required_upgrade := Progression.CATALOG.get_upgrade(requirement.upgrade_id)
		parts.append("%s Lv. %d" % [required_upgrade.display_name, requirement.required_level])
	return ", ".join(parts)


func _format_effects(upgrade: UpgradeDefinition) -> String:
	var parts: PackedStringArray = []
	for effect: StatEffect in upgrade.effects:
		parts.append(effect.describe())
	return "EFFECT: " + " · ".join(parts)
