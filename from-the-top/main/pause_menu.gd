extends PanelContainer

@export var music: AudioStreamPlayer
@export var slam_sound: AudioStreamPlayer

@export var resume_butt: Button

var game_overed: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if not game_overed:
			if get_tree().paused:
				unpause()
			else:
				pause()

func pause() -> void:
	if not game_overed:
		get_tree().paused = true
		show()
		music.volume_db = linear_to_db(1.0)
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(
			music, "pitch_scale", 0.75, 1.0
		)
		resume_butt.grab_focus()

func unpause() -> void:
	if not game_overed:
		get_tree().paused = false
		hide()
		music.volume_db = linear_to_db(1.0)
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		#tween.set_parallel()
		tween.tween_property(
			music, "pitch_scale", 1.0, 1.0
		)
		#tween.tween_property(
			#Engine, "time_scale", 1.0, 1.0
		#).from(0.1)
		#tween.tween_method(
			#tween.set_speed_scale, 10.0, 1.0, 1.0
		#)


func _on_restart_pressed() -> void:
	unpause()
	get_tree().reload_current_scene()

func _on_player_died() -> void:
	game_overed = true

func _on_resume_pressed() -> void:
	slam_sound.play()
	unpause()


func _on_resume_focus_entered() -> void:
	slam_sound.play()

func _on_menu_pressed() -> void:
	slam_sound.play()
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		music, "pitch_scale", 0.0, 1.0
	)
	SceneSwitcher.switch_to("res://main_menu/main_menu.tscn")

func _on_menu_focus_entered() -> void:
	slam_sound.play()
