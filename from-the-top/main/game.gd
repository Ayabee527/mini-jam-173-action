extends Node2D

@export var player: Player

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	return
	draw_dashed_line(
		player.global_position, get_global_mouse_position(),
		Color.WHITE, 1.0, 6.0
	)
