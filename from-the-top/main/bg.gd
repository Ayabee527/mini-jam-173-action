extends ColorRect

@export var amp: float = 8.0
@export var wavelength: float = 256.0 / 64.0

var move: float = 0.0

func _process(delta: float) -> void:
	queue_redraw()
	
	move += delta * wavelength
	move = fposmod(move, wavelength * PI)

func _draw() -> void:
	pass
