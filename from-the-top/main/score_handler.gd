extends Node

@export var score_label: RichTextLabel

var wave: int = 1
var score: int = 0:
	set = set_score
var last_score: int = 0

func _on_player_died() -> void:
	Global.save_endless_score(score)

func set_score(new_score: int = 0) -> void:
	score = max(0, new_score)
	
	var tween = create_tween()
	tween.tween_method(
		increment_score, last_score, score, 1.0
	)
	last_score = score

func increment_score(new_score: int):
	score_label.text = "[shake][wave][center]SCORE: "
	score_label.text += str(new_score)

func _on_wave_handler_enemy_killed(enemy: Node2D) -> void:
	score += 100 * wave


func _on_wave_handler_wave_cleared(size: int) -> void:
	wave += 1
