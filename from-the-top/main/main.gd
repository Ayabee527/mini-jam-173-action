extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") and OS.is_debug_build():
		get_tree().reload_current_scene()
