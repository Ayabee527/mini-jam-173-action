class_name VolumeSlider
extends HSlider

signal confirm_volume()

@export var bus_name: String = "Master"

var bus_index: int = 0

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func initialize_volume() -> void:
	set_value_no_signal(
		db_to_linear(
			AudioServer.get_bus_volume_db(bus_index)
		)
	)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index, linear_to_db(value)
	)


func _on_drag_ended(value_changed: bool) -> void:
	confirm_volume.emit()
