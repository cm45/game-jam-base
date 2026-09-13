class_name ProgressionTree
extends Control
## Draws upgrade requirements and creates one selectable button per definition.

signal upgrade_selected(upgrade_id: StringName)

const NODE_SIZE := Vector2(108, 40)

var _buttons: Dictionary[StringName, Button] = {}


func _ready() -> void:
	custom_minimum_size = Vector2(480, 144)
	Progression.currency_changed.connect(func(_id: StringName, _amount: int) -> void: refresh())
	Progression.upgrade_purchased.connect(func(_id: StringName, _level: int) -> void: refresh())
	Progression.progression_reset.connect(refresh)
	_build_buttons()


func refresh() -> void:
	for upgrade_id: StringName in _buttons:
		var button := _buttons[upgrade_id]
		var upgrade := Progression.CATALOG.get_upgrade(upgrade_id)
		var level := Progression.get_upgrade_level(upgrade_id)
		button.text = "%s\n%d / %d" % [upgrade.display_name, level, upgrade.max_level]
		button.modulate = Color.WHITE if level > 0 or Progression.can_purchase(upgrade_id) else Color(0.72, 0.72, 0.72, 1)
	queue_redraw()


func _build_buttons() -> void:
	for upgrade: UpgradeDefinition in Progression.CATALOG.upgrades:
		var button := Button.new()
		button.position = upgrade.tree_position
		button.size = NODE_SIZE
		button.add_theme_font_size_override("font_size", 8)
		button.tooltip_text = "%s\n%s" % [upgrade.display_name, upgrade.description]
		button.pressed.connect(func() -> void: upgrade_selected.emit(upgrade.id))
		add_child(button)
		_buttons[upgrade.id] = button
	refresh()


func _draw() -> void:
	for upgrade: UpgradeDefinition in Progression.CATALOG.upgrades:
		for requirement: UpgradeRequirement in upgrade.prerequisites:
			var source := Progression.CATALOG.get_upgrade(requirement.upgrade_id)
			if source == null:
				continue
			var from := source.tree_position + NODE_SIZE * 0.5
			var to := upgrade.tree_position + NODE_SIZE * 0.5
			var has_requirement := Progression.get_upgrade_level(source.id) >= requirement.required_level
			var line_color := Color(0.4, 0.82, 0.47, 1) if has_requirement else Color(0.32, 0.24, 0.18, 1)
			draw_line(from, to, line_color, 3.0, true)
