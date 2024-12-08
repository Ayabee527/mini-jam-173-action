extends MarginContainer

@export var button: Button

func _ready() -> void:
	button.grab_focus()

func hover() -> void:
	pass
