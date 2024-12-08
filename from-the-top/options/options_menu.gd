class_name OptionsMenu
extends PanelContainer

signal confirmed()

@export var back_butt: Button
@export var master_volume: VolumeSlider
@export var sound_volume: VolumeSlider

@export var keybind_buttons: Array[KeybindButton]

@export var volume_sliders: Array[VolumeSlider]

@export var awaiting_input: PanelContainer

@export var sound: AudioStreamPlayer

var hogging_input: bool = false
var connected: bool = false

func _ready() -> void:
	await owner.ready
	initialize()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and visible:
		if not hogging_input:
			SaveHandler.save_config()
			confirmed.emit()

func initialize() -> void:
	for keybind: KeybindButton in keybind_buttons:
		keybind.update_text()
	
	for slider: VolumeSlider in volume_sliders:
		slider.initialize_volume()
	
	if not connected:
		for keybind: KeybindButton in keybind_buttons:
			keybind.waiting.connect(
				func():
					hogging_input = true
					awaiting_input.show()
			)
		
		for keybind: KeybindButton in keybind_buttons:
			keybind.accepted.connect(
				func():
					awaiting_input.hide()
					for other_keybind: KeybindButton in keybind_buttons:
						other_keybind.update_text()
					await get_tree().process_frame
					await get_tree().process_frame
					hogging_input = false
			)
		
		back_butt.pressed.connect(_on_back_pressed)
		
		master_volume.confirm_volume.connect(_on_volume_slider_confirm_volume)
		sound_volume.confirm_volume.connect(_on_volume_slider_confirm_volume)
	
	if not connected:
		connected = true

func _on_back_pressed() -> void:
	SaveHandler.save_config()
	confirmed.emit()


func _on_volume_slider_confirm_volume() -> void:
	sound.play()

func _on_keybind_accepted() -> void:
	for keybind: KeybindButton in keybind_buttons:
		keybind.update_text()


func _on_visibility_changed() -> void:
	if visible:
		back_butt.grab_focus()
		initialize()
