extends Node2D


@export var time_to_crash: float = 120.0
@export var timer: Timer

var grow: float = 0.0

var radius: float = 384
var x_pos: float = 128.0

func _ready() -> void:
	spawn_planet()
	timer.start(time_to_crash)
	timer.timeout.connect(spawn_planet)

func _process(delta: float) -> void:
	queue_redraw()
	
	grow += delta
	grow = fposmod(grow, time_to_crash)

func _draw() -> void:
	var y_pos = 1024 - (grow * 2048.0 / time_to_crash)
	var atm_color = Util.BORDER_COLOR
	atm_color.a = 0.1
	var color = Util.BORDER_COLOR
	color.a = 0.5
	draw_circle(
		Vector2(x_pos, y_pos), radius * 1.5, atm_color, true
	)
	draw_circle(
		Vector2(x_pos, y_pos), radius + 2.0, Util.BG_COLOR, true
	)
	draw_circle(
		Vector2(x_pos, y_pos), radius, color, false, 1.0
	)

func spawn_planet() -> void:
	radius = randf_range(64.0, 256.0)
	x_pos = randf_range(-16.0, 272.0)
