extends Node
## Verifies the separate progression views reserve their intended desktop space.

const PROGRESSION_PANEL_SCENE := preload("res://features/progression/ui/progression_panel.tscn")
const TAB_BAR_ALLOWANCE := 30.0


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var panel: ProgressionPanel = PROGRESSION_PANEL_SCENE.instantiate()
	add_child(panel)
	await get_tree().process_frame
	var views: TabContainer = panel.get_node("Center/Panel/Margin/Layout/Content/Views")
	var shop_scroll: ScrollContainer = panel.get_node("Center/Panel/Margin/Layout/Content/Views/Shop")
	var shop_list: VBoxContainer = panel.get_node("Center/Panel/Margin/Layout/Content/Views/Shop/ShopList")
	var tree: ProgressionTree = panel.get_node("Center/Panel/Margin/Layout/Content/Views/SkillTree/TreeScroll/ProgressionTree")
	if not _require(panel.size == Vector2(1280, 720), "Fullscreen panels should use the 1280×720 UI canvas."):
		return
	if not _require(is_equal_approx(panel.scale.x, 0.5), "Fullscreen panels should scale into the 640×360 world canvas."):
		return
	if not _require(shop_list.get_child_count() == Progression.CATALOG.shop_upgrades.size(), "Shop should create one card per shop improvement."):
		return
	if not _require(shop_list.get_child_count() >= 6, "The example shop should demonstrate six visible improvements."):
		return
	if not _require(_visible_card_capacity(views) >= 6, "Shop viewport should fit six cards before scrolling."):
		return
	var sixth_card := shop_list.get_child(5) as Control
	if not _require(sixth_card != null and shop_scroll.get_global_rect().encloses(sixth_card.get_global_rect()), "The sixth shop card should be fully visible without scrolling."):
		return
	var panel_rect := panel.get_node("Center/Panel") as Control
	if not _require(panel_rect.get_global_rect().size.x <= 580.0 and panel_rect.get_global_rect().size.y <= 320.0, "Scaled progression panel should leave a desktop margin around the world canvas."):
		return
	if not _require(tree.custom_minimum_size == ProgressionTree.BASE_CANVAS_SIZE, "Skill tree should use the full skill canvas at its default zoom."):
		return
	if not _require(Progression.CATALOG.skill_nodes.size() >= 6, "The example tree should demonstrate six skill nodes."):
		return
	for skill: UpgradeDefinition in Progression.CATALOG.skill_nodes:
		var stays_in_canvas := skill.tree_position.x + ProgressionTree.NODE_SIZE.x <= ProgressionTree.BASE_CANVAS_SIZE.x and skill.tree_position.y + ProgressionTree.NODE_SIZE.y <= ProgressionTree.BASE_CANVAS_SIZE.y
		if not _require(stays_in_canvas, "Skill '%s' falls outside the tree canvas." % skill.id):
			return
	panel.queue_free()
	await get_tree().process_frame
	print("progression_layout_smoke: PASS")
	get_tree().quit(0)


func _visible_card_capacity(views: TabContainer) -> int:
	var card_height := 58.0
	var card_separation := 6.0
	var content_height := views.custom_minimum_size.y - TAB_BAR_ALLOWANCE
	return floori((content_height + card_separation) / (card_height + card_separation))


func _require(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error("progression_layout_smoke: %s" % message)
	get_tree().quit(1)
	return false
