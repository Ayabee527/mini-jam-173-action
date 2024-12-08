extends Control

@export var play_button: Button
@export var cut: ColorRect
@export var slam_sound: AudioStreamPlayer
@export var music: AudioStreamPlayer
@export var play_sound: AudioStreamPlayer

@export var options_menu: OptionsMenu
@export var online_menu: OnlineMenu
@export var stats_menu: StatsMenu
@export var credits_menu: PanelContainer
@export var credit_back_butt: Button
@export var quit_butt: Button

var quitting: bool = false

func _ready() -> void:
	SceneSwitcher.switch_in()
	await get_tree().process_frame
	SaveHandler.load_config()
	
	MainCam.min_shake_stength = 2.0
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		music, "pitch_scale", 1.0, 2.0
	).from( 0.0 )
	
	if OS.has_feature("web"):
		quit_butt.hide()


func _on_play_pressed() -> void:
	if quitting:
		return
	
	quitting = true
	play_sound.play()
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		music, "pitch_scale", 0.0, 1.0
	).from( 1.0 )
	SceneSwitcher.switch_to("res://main/main.tscn")


func _on_leaderboard_pressed() -> void:
	if quitting:
		return
	
	slam_sound.play()
	online_menu.show()


func _on_quit_pressed() -> void:
	if quitting:
		return
	
	cut.show()
	slam_sound.play()
	quitting = true
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		music, "pitch_scale", 0.0, 1.5
	).from( 1.0 )
	
	var window := get_window()
	
	var window_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	window_tween.tween_property(
		window, "position:y", -window.size.y * 2.0, 2.0
	)
	await window_tween.finished
	get_tree().quit()


func _on_play_focus_entered() -> void:
	slam_sound.play()


func _on_leaderboard_focus_entered() -> void:
	slam_sound.play()


func _on_quit_focus_entered() -> void:
	slam_sound.play()


func _on_credits_pressed() -> void:
	if quitting:
		return
	
	slam_sound.play()
	credits_menu.show()
	credit_back_butt.grab_focus()


func _on_credits_focus_entered() -> void:
	slam_sound.play()


func _on_options_pressed() -> void:
	if quitting:
		return
	
	slam_sound.play()
	options_menu.show()


func _on_options_focus_entered() -> void:
	slam_sound.play()


func _on_options_menu_confirmed() -> void:
	options_menu.hide()
	play_button.grab_focus()


func _on_scores_pressed() -> void:
	if quitting:
		return
	
	slam_sound.play()
	stats_menu.show()


func _on_scores_focus_entered() -> void:
	slam_sound.play()


func _on_online_menu_back() -> void:
	online_menu.hide()
	play_button.grab_focus()


func _on_stats_menu_back() -> void:
	stats_menu.hide()
	play_button.grab_focus()


func _on_goals_pressed() -> void:
	if quitting:
		return
	
	slam_sound.play()


func _on_goals_focus_entered() -> void:
	slam_sound.play()


func _on_back_pressed() -> void:
	credits_menu.hide()
	slam_sound.play()
	play_button.grab_focus()
