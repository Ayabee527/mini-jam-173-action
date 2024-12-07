class_name EnemyMeteor
extends RigidBody2D

@export var base_radius: float = 8.0

@export var coll_shape: CollisionShape2D
@export var hit_coll: CollisionShape2D
@export var hurt_coll: CollisionShape2D

var player: Player
var shape: PackedVector2Array
var outline: PackedVector2Array

func _ready() -> void:
	var coll := CircleShape2D.new()
	coll.radius = base_radius
	coll_shape.shape = coll
	hit_coll.shape = coll
	hurt_coll.shape = coll
	
	player = get_tree().get_first_node_in_group("player")
	shape = generate_shape(randi_range(4, 10), base_radius - 4.0, base_radius, true)
	outline = Util.scale_polygon(shape, (base_radius + 2.0) / base_radius)

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_colored_polygon(
		outline, Util.BG_COLOR
	)
	draw_polyline(
		shape, Util.BORDER_COLOR, 1.0
	)

func generate_shape(detail: int, min_radius: float, max_radius: float, closed: bool = true, offset: Vector2 = Vector2.ZERO, rotation: float = 0.0) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i: int in range(detail):
		var radius: float = randf_range(min_radius, max_radius)
		var point := Vector2.from_angle( deg_to_rad(rotation) + (TAU * ( float(i) / detail ))) * radius
		points.append(point + offset)
	
	if closed:
		points.append(points[0])
	
	return points


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(knockback)
