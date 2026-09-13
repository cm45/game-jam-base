class_name ProgressionPanel
extends Control
## Feature-owned shop and tree view. It displays state but delegates all rules
## to the Progression service.

signal close_requested

const SHOP_ITEM_SCENE := preload("res://features/progression/ui/upgrade_shop_item.tscn")

var _selected_upgrade_id: StringName

@onready var _wallet: HBoxContainer = %Wallet
@onready var _shop_list: VBoxContainer = %ShopList
@onready var _tree: ProgressionTree = %ProgressionTree
@onready var _selected_title: Label = %SelectedTitle
@onready var _selected_description: Label = %SelectedDescription
@onready var _selected_level: Label = %SelectedLevel
@onready var _selected_effects: Label = %SelectedEffects
@onready var _selected_cost: Label = %SelectedCost
@onready var _purchase_button: Button = %PurchaseButton
@onready var _purchase_notice: Label = %PurchaseNotice


func _ready() -> void:
	_tree.upgrade_selected.connect(select_upgrade)
	%CloseButton.pressed.connect(func() -> void: close_requested.emit())
	%GrantGoldButton.pressed.connect(func() -> void: Progression.grant_currency(&"gold", 25))
	%GrantInsightButton.pressed.connect(func() -> void: Progression.grant_currency(&"insight", 1))
	%PurchaseButton.pressed.connect(_purchase_selected_upgrade)
	Progression.currency_changed.connect(func(_id: StringName, _amount: int) -> void: refresh())
	Progression.upgrade_purchased.connect(func(_id: StringName, _level: int) -> void: refresh())
	Progression.progression_reset.connect(refresh)
	_build_shop()
	if not Progression.CATALOG.upgrades.is_empty():
		select_upgrade(Progression.CATALOG.upgrades[0].id)
	refresh()


func select_upgrade(upgrade_id: StringName) -> void:
	if Progression.CATALOG.get_upgrade(upgrade_id) == null:
		return
	_selected_upgrade_id = upgrade_id
	_purchase_notice.text = ""
	refresh()


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
	for upgrade: UpgradeDefinition in Progression.CATALOG.upgrades:
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
		_wallet.add_child(label)


func _refresh_selected_upgrade() -> void:
	var upgrade := Progression.CATALOG.get_upgrade(_selected_upgrade_id)
	if upgrade == null:
		return
	var level := Progression.get_upgrade_level(upgrade.id)
	_selected_title.text = upgrade.display_name
	_selected_description.text = upgrade.description
	_selected_level.text = "LEVEL %d / %d" % [level, upgrade.max_level]
	_selected_effects.text = _format_effects(upgrade)
	_selected_cost.text = _format_cost(Progression.get_upgrade_cost(upgrade.id))
	_purchase_button.disabled = not Progression.can_purchase(upgrade.id)
	_purchase_button.text = "MAX LEVEL" if level >= upgrade.max_level else "PURCHASE"
	if level >= upgrade.max_level:
		_purchase_notice.text = "This upgrade is complete."
	elif not Progression.get_unmet_requirements(upgrade.id).is_empty():
		_purchase_notice.text = "Requires: %s" % _format_requirements(upgrade)
	elif not Progression.can_purchase(upgrade.id):
		_purchase_notice.text = "Earn more permanent currency in a run."
	elif _purchase_notice.text.is_empty():
		_purchase_notice.text = "Ready to purchase."


func _purchase_selected_upgrade() -> void:
	var result := Progression.try_purchase(_selected_upgrade_id)
	_purchase_notice.text = String(result.get("message", "Purchase failed."))
	refresh()


func _format_cost(cost: Dictionary[StringName, int]) -> String:
	if cost.is_empty():
		return "COST: MAX LEVEL"
	var parts: PackedStringArray = []
	for currency_id: StringName in cost:
		var currency := Progression.CATALOG.get_currency(currency_id)
		parts.append("%d %s" % [cost[currency_id], currency.display_name])
	return "COST: " + " • ".join(parts)


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
	return "EFFECT: " + " • ".join(parts)
