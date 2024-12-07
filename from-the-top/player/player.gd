class_name Player
extends RigidBody2D

@export var grapple_reach: float = 128.0
@export var grapple_speed: float = 1024.0
@export var move_speed: float = 275.0

@export var sides: int = 5
@export var radius: float = 4.0

@export_group("Inner Dependencies")
@export var coll_shape: CollisionShape2D
@export var floor_detect: RayCast2D
@export var grapple_detect: RayCast2D
@export var bouncer: RayCast2D

var grapple_point: Vector2

func _ready() -> void:
	grapple_detect.target_position = Vector2.RIGHT * grapple_reach

func _process(delta: float) -> void:
	queue_redraw()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass

func _physics_process(delta: float) -> void:
	grapple_detect.look_at(get_global_mouse_position())
	bouncer.look_at(global_position + linear_velocity)
	floor_detect.global_rotation = 0.0

func _draw() -> void:
	draw_shape()
	draw_reach()
	draw_grapple_point()

func draw_shape() -> void:
	draw_circle(
		Vector2.ZERO, radius + 1.0, Util.BG_COLOR, true
	)
	var shape: PackedVector2Array = Util.generate_polygon(
		sides, radius, true
	)
	draw_polyline(
		shape, Color.WHITE, 2.0
	)

func draw_reach() -> void:
	draw_set_transform(Vector2.ZERO, -global_rotation)
	var reach_shape := Util.generate_polygon(64, grapple_reach, false)
	draw_circle(
		Vector2.ZERO, grapple_reach - 2.0, Color(0.25, 0.25, 0.25, 0.1), true
	)
	draw_multiline(
		reach_shape, Color(0.5, 0.5, 0.5, 0.5), 1.0
	)

func draw_grapple_point() -> void:
	draw_set_transform(Vector2.ZERO, -global_rotation + PI)
	draw_circle(
		global_position - grapple_point, 4.0, Color.WHITE, false, 1.0
	)
	draw_dashed_line(
		global_position - grapple_point + (Vector2.LEFT * 6.0),
		global_position - grapple_point + (Vector2.RIGHT * 6.0),
		Color.WHITE, 1.0
	)
	draw_dashed_line(
		global_position - grapple_point + (Vector2.UP * 6.0),
		global_position - grapple_point + (Vector2.DOWN * 6.0),
		Color.WHITE, 1.0
	)

func get_move_axis() -> float:
	return Input.get_axis("move_left", "move_right")


func _on_body_entered(body: Node) -> void:
	physics_material_override.bounce = 0.5


func _on_bonk_check_body_entered(body: Node2D) -> void:
	if bouncer.is_colliding():
		var normal := bouncer.get_collision_normal()
		linear_velocity = linear_velocity.bounce(normal)
	
	MainCam.shake(15.0, 10.0, 3.0)
