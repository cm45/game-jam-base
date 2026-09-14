class_name ProgressionTree
extends Control
## Draws the Insight-only skill tree with mouse panning and zoom controls.

signal upgrade_selected(upgrade_id: StringName)

const BASE_CANVAS_SIZE := Vector2(980, 440)
const NODE_SIZE := Vector2(164, 64)
const MIN_ZOOM := 0.1
const MAX_ZOOM := 1.35

var _buttons: Dictionary[StringName, Button] = {}
var _zoom := 1.0
var _is_panning := false
var _last_pointer := Vector2.ZERO


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	Progression.currency_changed.connect(func(_id: StringName, _amount: int) -> void: refresh())
	Progression.skill_unlocked.connect(func(_id: StringName, _level: int) -> void: refresh())
	Progression.progression_reset.connect(refresh)
	_build_buttons()
	_apply_zoom()
	call_deferred("center_on_root")


func refresh() -> void:
	for skill_id: StringName in _buttons:
		var button := _buttons[skill_id]
		var skill := Progression.CATALOG.get_upgrade(skill_id)
		var level := Progression.get_skill_level(skill_id)
		button.text = "%s\n%d / %d" % [skill.display_name, level, skill.max_level]
		if level > 0:
			button.modulate = Color(0.72, 1.0, 0.76, 1.0)
		elif Progression.can_unlock_skill(skill_id):
			button.modulate = Color.WHITE
		else:
			button.modulate = Color(0.66, 0.66, 0.66, 1.0)
	queue_redraw()


func zoom_in() -> void:
	set_zoom(_zoom + 0.15)


func zoom_out() -> void:
	set_zoom(_zoom - 0.15)


func fit_to_tree() -> void:
	var scroll := get_parent() as ScrollContainer
	if scroll == null or scroll.size.x <= 0.0 or scroll.size.y <= 0.0:
		return
	# Leave space for container borders; derive zoom from both available axes.
	var available := scroll.size - Vector2(24, 24)
	set_zoom(minf(available.x / BASE_CANVAS_SIZE.x, available.y / BASE_CANVAS_SIZE.y))
	# Fit displays the whole canvas; manual zoom restores scrolling.
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.scroll_horizontal = 0
	scroll.scroll_vertical = 0


func set_zoom(value: float) -> void:
	var scroll := get_parent() as ScrollContainer
	if scroll != null:
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_zoom = clampf(value, MIN_ZOOM, MAX_ZOOM)
	_apply_zoom()


func center_on_root() -> void:
	var scroll := get_parent() as ScrollContainer
	if scroll == null or Progression.CATALOG.skill_nodes.is_empty():
		return
	var root := Progression.CATALOG.skill_nodes[0]
	var target := root.tree_position * _zoom
	scroll.scroll_horizontal = maxi(0, roundi(target.x - scroll.size.x * 0.25))
	scroll.scroll_vertical = maxi(0, roundi(target.y - scroll.size.y * 0.5))


func _build_buttons() -> void:
	for skill: UpgradeDefinition in Progression.CATALOG.skill_nodes:
		var button := Button.new()
		button.tooltip_text = "%s\n%s" % [skill.display_name, skill.description]
		button.pressed.connect(func() -> void: upgrade_selected.emit(skill.id))
		add_child(button)
		_buttons[skill.id] = button
	refresh()


func _apply_zoom() -> void:
	custom_minimum_size = BASE_CANVAS_SIZE * _zoom
	size = custom_minimum_size
	var scroll := get_parent() as ScrollContainer
	if scroll != null:
		scroll.queue_sort()
	for skill: UpgradeDefinition in Progression.CATALOG.skill_nodes:
		var button := _buttons.get(skill.id) as Button
		if button == null:
			continue
		button.position = skill.tree_position * _zoom
		button.size = NODE_SIZE * _zoom
		button.add_theme_font_size_override("font_size", roundi(11 * _zoom))
	queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		_is_panning = event.pressed
		_last_pointer = event.position
		accept_event()
	elif event is InputEventMouseMotion and _is_panning:
		var scroll := get_parent() as ScrollContainer
		if scroll == null:
			return
		var movement: Vector2 = event.position - _last_pointer
		scroll.scroll_horizontal = maxi(0, roundi(scroll.scroll_horizontal - movement.x))
		scroll.scroll_vertical = maxi(0, roundi(scroll.scroll_vertical - movement.y))
		_last_pointer = event.position
		accept_event()


func _draw() -> void:
	for skill: UpgradeDefinition in Progression.CATALOG.skill_nodes:
		for requirement: UpgradeRequirement in skill.prerequisites:
			var source := Progression.CATALOG.get_upgrade(requirement.upgrade_id)
			if source == null:
				continue
			var from := (source.tree_position + NODE_SIZE * 0.5) * _zoom
			var to := (skill.tree_position + NODE_SIZE * 0.5) * _zoom
			var has_requirement := Progression.get_skill_level(source.id) >= requirement.required_level
			var line_color := Color(0.4, 0.82, 0.47, 1) if has_requirement else Color(0.32, 0.24, 0.18, 1)
			draw_line(from, to, line_color, 4.0 * _zoom, true)
