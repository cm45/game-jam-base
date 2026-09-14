extends Button
## Native tooltips are separate popups and do not inherit UIScreen's half scale.
## Lay this popup out in the 640×360 viewport's units, independently of tree zoom.

const PANEL_STYLE := preload("res://ui/theme/hud_panel.tres")
const BODY_FONT := preload("res://ui/theme/readable_body_font.tres")
const SHARED_THEME := preload("res://ui/theme/game_jam_theme.tres")
const TEXT_WIDTH := 168.0


func _init() -> void:
	# Godot wraps custom tooltips in a TooltipPanel. Only our wood panel draws.
	theme = SHARED_THEME.duplicate() as Theme
	theme.set_stylebox("panel", "TooltipPanel", StyleBoxEmpty.new())


func _make_custom_tooltip(for_text: String) -> Object:
	var panel := PanelContainer.new()
	panel.theme = SHARED_THEME
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := PANEL_STYLE.duplicate() as StyleBoxTexture
	style.content_margin_left = 8.0
	style.content_margin_right = 8.0
	style.content_margin_top = 7.0
	style.content_margin_bottom = 7.0
	panel.add_theme_stylebox_override("panel", style)
	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 4)
	panel.add_child(layout)
	var parts := for_text.split("\n", true, 1)
	var heading := Label.new()
	heading.text = parts[0]
	heading.custom_minimum_size.x = TEXT_WIDTH
	heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	heading.add_theme_font_size_override("font_size", 10)
	heading.add_theme_color_override("font_color", Color("302013"))
	layout.add_child(heading)
	var description := Label.new()
	description.text = parts[1] if parts.size() > 1 else ""
	description.custom_minimum_size.x = TEXT_WIDTH
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.add_theme_font_override("font", BODY_FONT)
	description.add_theme_font_size_override("font_size", 9)
	description.add_theme_color_override("font_color", Color("302013"))
	layout.add_child(description)
	return panel
