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
	var skill_button := tree.get_child(0) as Button
	var tooltip := skill_button.call("_make_custom_tooltip", skill_button.tooltip_text) as Control
	add_child(tooltip)
	await get_tree().process_frame
	await get_tree().process_frame
	if not _require(tooltip.size.x <= 200.0 and tooltip.size.y <= 100.0, "Skill tooltip must stay compact in viewport coordinates."):
		return
	tooltip.queue_free()
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
	for scene_path: String in ["res://features/progression/ui/shop_window.tscn", "res://features/progression/ui/skill_tree_window.tscn"]:
		var station := (load(scene_path) as PackedScene).instantiate() as ProgressionPanel
		add_child(station)
		await get_tree().process_frame
		var station_views := station.get_node("Center/Panel/Margin/Layout/Content/Views") as TabContainer
		var is_shop := station.window_mode == ProgressionPanel.WindowMode.SHOP
		var expected_tab := 0 if is_shop else 1
		if not _require(not station_views.tabs_visible and station_views.current_tab == expected_tab, "Station window should expose only its own system."):
			return
		station.show_skill_tree() if is_shop else station.show_shop()
		if not _require(station_views.current_tab == expected_tab, "Station window must reject cross-system navigation."):
			return
		station.queue_free()
		await get_tree().process_frame
	var camp := (load("res://game/home.tscn") as PackedScene).instantiate()
	add_child(camp)
	await get_tree().process_frame
	var grass := camp.get_node("Terrain/Grass") as TileMapLayer
	if not _require(grass.get_used_cells().size() == 920 and grass.get_script() == null, "Home ground must be saved editable tiles, not runtime drawing."):
		return
	if not _require(grass.tile_set.resource_path == "res://game/world/terrain_tileset.tres" and camp.get_node("Terrain").position == Vector2.ZERO, "Home terrain must use the shared palette and cover the viewport from its top-left edge."):
		return
	var shop_window := camp.get_node("Interface/ShopWindow") as Control
	var skill_window := camp.get_node("Interface/SkillTreeWindow") as Control
	camp.get_node("Merchant").activated.emit(null)
	if not _require(shop_window.visible and not skill_window.visible, "Merchant must open only the shop."):
		return
	camp.get_node("Mentor").activated.emit(null)
	if not _require(skill_window.visible and not shop_window.visible, "Mentor must open only skills."):
		return
	var fitted_tree := skill_window.get_node("Center/Panel/Margin/Layout/Content/Views/SkillTree/TreeScroll/ProgressionTree") as ProgressionTree
	await get_tree().process_frame
	fitted_tree.fit_to_tree()
	await get_tree().process_frame
	await get_tree().process_frame
	var tree_scroll := fitted_tree.get_parent() as ScrollContainer
	if not _require(not tree_scroll.get_h_scroll_bar().visible and not tree_scroll.get_v_scroll_bar().visible, "Fit must remove both tree scrollbars."):
		return
	if not _require(AppShell.layer > (camp.get_node("Interface") as CanvasLayer).layer, "Pause must draw above station windows."):
		return
	for child: Node in fitted_tree.get_children():
		if child is Button and not _require(Rect2(Vector2.ZERO, fitted_tree.size).encloses(child.get_rect()), "Fit must contain every skill node."):
			return
	camp.queue_free()
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
