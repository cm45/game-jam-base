class_name PauseMenu
extends UIScreen
## Pause, settings, controls, and save-reset interface for the foundation.

const MAIN_PAGE: StringName = &"main"
const SETTINGS_PAGE: StringName = &"settings"
const CONTROLS_PAGE: StringName = &"controls"

@onready var _main_page: Control = %MainPage
@onready var _settings_page: Control = %SettingsPage
@onready var _controls_page: Control = %ControlsPage
@onready var _page_title: Label = %PageTitle
@onready var _resume_button: Button = %ResumeButton
@onready var _master_slider: HSlider = %MasterSlider
@onready var _music_slider: HSlider = %MusicSlider
@onready var _sfx_slider: HSlider = %SfxSlider
@onready var _binding_list: Label = %BindingList
@onready var _reset_confirmation: Control = %ResetConfirmation
@onready var _preview_sound: AudioStreamPlayer = %PreviewSound


func _ready() -> void:
	super()
	hide()
	_master_slider.value = AudioSettings.get_volume(AudioSettings.MASTER_BUS)
	_music_slider.value = AudioSettings.get_volume(AudioSettings.MUSIC_BUS)
	_sfx_slider.value = AudioSettings.get_volume(AudioSettings.SFX_BUS)
	_binding_list.text = _build_binding_list()
	_resume_button.pressed.connect(close_menu)
	%SettingsButton.pressed.connect(func() -> void: _show_page(SETTINGS_PAGE))
	%ControlsButton.pressed.connect(func() -> void: _show_page(CONTROLS_PAGE))
	%SettingsBackButton.pressed.connect(func() -> void: _show_page(MAIN_PAGE))
	%ControlsBackButton.pressed.connect(func() -> void: _show_page(MAIN_PAGE))
	%HubButton.pressed.connect(_return_to_hub)
	%QuitButton.pressed.connect(_quit_game)
	%ResetButton.pressed.connect(func() -> void: _reset_confirmation.show())
	%CancelResetButton.pressed.connect(func() -> void: _reset_confirmation.hide())
	%ConfirmResetButton.pressed.connect(_reset_save_data)
	%PreviewSoundButton.pressed.connect(_play_preview_sound)
	_master_slider.value_changed.connect(_set_master_volume)
	_music_slider.value_changed.connect(_set_music_volume)
	_sfx_slider.value_changed.connect(_set_sfx_volume)


func is_open() -> bool:
	return visible


func open_menu(page: StringName = MAIN_PAGE) -> void:
	show()
	get_tree().paused = true
	_show_page(page)
	call_deferred("_focus_current_page")


func close_menu() -> void:
	if not visible:
		return
	hide()
	get_tree().paused = false


func _show_page(page: StringName) -> void:
	_main_page.visible = page == MAIN_PAGE
	_settings_page.visible = page == SETTINGS_PAGE
	_controls_page.visible = page == CONTROLS_PAGE
	_reset_confirmation.hide()
	match page:
		SETTINGS_PAGE:
			_page_title.text = "SETTINGS"
		CONTROLS_PAGE:
			_page_title.text = "KEYBINDS"
		_:
			_page_title.text = "PAUSED"


func _focus_current_page() -> void:
	if _main_page.visible:
		_resume_button.grab_focus()
	elif _settings_page.visible:
		_master_slider.grab_focus()
	else:
		%ControlsBackButton.grab_focus()


func _set_master_volume(value: float) -> void:
	AudioSettings.set_volume(AudioSettings.MASTER_BUS, value)


func _set_music_volume(value: float) -> void:
	AudioSettings.set_volume(AudioSettings.MUSIC_BUS, value)


func _set_sfx_volume(value: float) -> void:
	AudioSettings.set_volume(AudioSettings.SFX_BUS, value)


func _reset_save_data() -> void:
	SaveStore.reset_all()
	AudioSettings.restore_defaults()
	_master_slider.value = AudioSettings.get_volume(AudioSettings.MASTER_BUS)
	_music_slider.value = AudioSettings.get_volume(AudioSettings.MUSIC_BUS)
	_sfx_slider.value = AudioSettings.get_volume(AudioSettings.SFX_BUS)
	_reset_confirmation.hide()


func _play_preview_sound() -> void:
	_preview_sound.play()


func _return_to_hub() -> void:
	close_menu()
	SceneRouter.return_to_foundation_hub()


func _quit_game() -> void:
	get_tree().quit()


func _build_binding_list() -> String:
	return "Move: %s\nInteract: %s\nPause: %s\nConfirm: %s\nCancel: %s" % [
		InputActions.get_binding_text(InputActions.MOVE_UP),
		InputActions.get_binding_text(InputActions.INTERACT),
		InputActions.get_binding_text(InputActions.PAUSE),
		InputActions.get_binding_text(InputActions.CONFIRM),
		InputActions.get_binding_text(InputActions.CANCEL),
	]
