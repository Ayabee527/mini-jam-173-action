extends Control

func _ready() -> void:
	MainCam.min_shake_stength = 0.0

func switch() -> void:
	SceneSwitcher.switch_to("res://main_menu/main_menu.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	switch()
