extends Node

const BG_COLOR: Color = Color("0d0729")
const BORDER_COLOR: Color = Color("e3c835")

func generate_polygon(detail: int, radius: float, closed: bool = true, offset: Vector2 = Vector2.ZERO, rotation: float = 0.0) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i: int in range(detail):
		var point := Vector2.from_angle( deg_to_rad(rotation) + (TAU * ( float(i) / detail ))) * radius
		points.append(point + offset)
	
	if closed:
		points.append(points[0])
	
	return points
