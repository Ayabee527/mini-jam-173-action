extends Node2D

func _ready() -> void:
	MainCam.min_shake_stength = 2.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") and OS.is_debug_build():
		get_tree().reload_current_scene()
