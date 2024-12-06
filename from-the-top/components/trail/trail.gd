class_name Trail
extends Line2D

@export var length: int = 16

var default_width: float = 4.0

func _ready() -> void:
	default_width = width

func _process(_delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	global_scale = Vector2.ONE
	
	add_point( get_parent().global_position )
	
	while get_point_count() > length:
		remove_point(0)

func destroy() -> void:
	clear_points()
