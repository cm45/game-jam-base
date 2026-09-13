extends Node
## Verifies the compact progression layout keeps its intended visible capacity.

const PROGRESSION_PANEL_SCENE := preload("res://features/progression/ui/progression_panel.tscn")
const TAB_BAR_ALLOWANCE := 24.0
const CARD_HEIGHT := 32.0
const CARD_SEPARATION := 4.0


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var panel: ProgressionPanel = PROGRESSION_PANEL_SCENE.instantiate()
	add_child(panel)
	await get_tree().process_frame
	var views: TabContainer = panel.get_node("Center/Panel/Margin/Layout/Views")
	var shop_list: GridContainer = panel.get_node("Center/Panel/Margin/Layout/Views/Shop/ShopList")
	var tree: ProgressionTree = panel.get_node("Center/Panel/Margin/Layout/Views/SkillTree/ProgressionTree")
	if not _require(shop_list.columns == 2, "Shop should use two columns."):
		return
	if not _require(shop_list.get_child_count() == Progression.CATALOG.upgrades.size(), "Shop should create one card per upgrade."):
		return
	if not _require(_visible_card_capacity(views) >= 6, "Shop viewport should fit six compact cards."):
		return
	if not _require(tree.custom_minimum_size == Vector2(480, 144), "Skill Tree should use the compact canvas."):
		return
	for upgrade: UpgradeDefinition in Progression.CATALOG.upgrades:
		if not _require(upgrade.tree_position.y + ProgressionTree.NODE_SIZE.y <= tree.custom_minimum_size.y, "Upgrade '%s' falls outside the Skill Tree canvas." % upgrade.id):
			return
	panel.queue_free()
	await get_tree().process_frame
	print("progression_layout_smoke: PASS")
	get_tree().quit(0)


func _visible_card_capacity(views: TabContainer) -> int:
	var content_height := views.custom_minimum_size.y - TAB_BAR_ALLOWANCE
	var rows := floori((content_height + CARD_SEPARATION) / (CARD_HEIGHT + CARD_SEPARATION))
	return rows * 2


func _require(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error("progression_layout_smoke: %s" % message)
	get_tree().quit(1)
	return false
