extends Node2D

@export var player: Player

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	pass
