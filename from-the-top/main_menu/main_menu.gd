extends Control

const LEADERBOARD_API = "97LLX6KMs11oHRJNs7waM1Z7kY9mtEDD1EXe6d2j"
const LEADERBOARD_ID = "stardustcrusader"

@export var cut: ColorRect
@export var slam_sound: AudioStreamPlayer
@export var music: AudioStreamPlayer
@export var play_sound: AudioStreamPlayer

var quitting: bool = false

func _ready() -> void:
	SceneSwitcher.switch_in()
	await get_tree().process_frame
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		music, "pitch_scale", 1.0, 2.0
	).from( 0.0 )


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


func _on_credits_focus_entered() -> void:
	slam_sound.play()
