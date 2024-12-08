extends Node2D

@export var musik: AudioStreamPlayer

func _ready() -> void:
	MainCam.min_shake_stength = 2.0
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		musik, "pitch_scale", 1.0, 2.0
	).from(0.0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") and OS.is_debug_build():
		get_tree().reload_current_scene()


func _on_player_died() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		musik, "pitch_scale", 0.0, 5.0
	).from(1.0)
