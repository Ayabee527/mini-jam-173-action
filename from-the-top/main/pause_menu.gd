extends PanelContainer

@export var music: AudioStreamPlayer

@export var unpause_butt: Button
@export var menu_butt: Button

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
		music.pitch_scale = 0.5
		unpause_butt.grab_focus()

func unpause() -> void:
	if not game_overed:
		get_tree().paused = false
		hide()
		music.volume_db = linear_to_db(1.0)
		music.pitch_scale = 1.0


func _on_menu_pressed() -> void:
	unpause()
	SceneSwitcher.switch_to("res://main_menu/main_menu.tscn")


func _on_restart_pressed() -> void:
	unpause()
	get_tree().reload_current_scene()

func _on_player_died() -> void:
	game_overed = true


func _on_unpause_pressed() -> void:
	unpause()
