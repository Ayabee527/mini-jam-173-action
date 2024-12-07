extends Node2D

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_set_transform(MainCam.offset)
	var radius: float = 384.0
	var atm_color = Util.BORDER_COLOR
	atm_color.a = 0.1
	var color = Util.BORDER_COLOR
	color.a = 0.5
	var center := Vector2(256.0, 512.0)
	draw_circle(
		center, radius * 1.5, atm_color, true
	)
	draw_circle(
		center, radius + 2.0, Util.BG_COLOR, true
	)
	draw_circle(
		center, radius, color, false, 1.0
	)
