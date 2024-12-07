extends Node2D

@export var sides: int = 3
@export var radius: float = 4.0

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_shape()
	draw_engine()

func draw_shape() -> void:
	var shape: PackedVector2Array = Util.generate_polygon(
		sides, radius, true
	)
	var outline: PackedVector2Array = Util.generate_polygon(
		sides, radius + 4.0, true
	)
	draw_colored_polygon(
		outline, Util.BG_COLOR
	)
	draw_polyline(
		shape, Color.WHITE, 1.0
	)

func draw_engine() -> void:
	draw_circle(
		Vector2.LEFT * 6.0, 3.0, Util.BG_COLOR, true
	)
	draw_circle(
		Vector2.LEFT * 6.0, 1.0, Color.WHITE, true
	)
