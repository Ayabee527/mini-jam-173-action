extends Node2D

@export var ship: Node2D
@export var anim_player: AnimationPlayer

@export var score_label: RichTextLabel

var restartable: bool = false

func _input(event: InputEvent) -> void:
	if restartable and event.is_pressed():
		restartable = false
		anim_player.play("cut")

func _ready() -> void:
	MainCam.min_shake_stength = 2.0
	await get_tree().create_timer(1.0, false).timeout
	anim_player.play("crash")
	score_label.text = "[right][wave][shake][color='e3c835']SCORE: " + str(Global.latest_endless_score)

func shake() -> void:
	MainCam.shake(20.0, 10.0, 5.0)
	MainCam.min_shake_stength = 2.0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"crash":
			anim_player.play("flash")
			MainCam.min_shake_stength = 0.0
		"flash":
			anim_player.play("reveal")
		"reveal":
			restartable = true

func switch() -> void:
	if not Global.online_prompted and Global.username.strip_edges().is_empty():
		SceneSwitcher.switch_to("res://main/online_prompt/online_prompt.tscn")
	else:
		SceneSwitcher.switch_to("res://main/main.tscn")
