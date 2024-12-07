class_name EnemyUFO
extends RigidBody2D

signal died()

@export var max_speed: float = 150.0

@export var sides: int = 3
@export var radius: float = 4.0

@export_group("Inner Dependencies")
@export var coll_shape: CollisionShape2D
@export var hurt_coll: CollisionShape2D
@export var hit_coll: CollisionShape2D
@export var trail: GPUParticles2D
@export var health: Health

var player: Player

var color: Color = Color.RED
var draw_scale: float = 1.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	queue_redraw()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = state.linear_velocity.limit_length(max_speed)

func _physics_process(delta: float) -> void:
	pass

func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE * draw_scale)
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
		shape, color, 1.0
	)

func draw_engine() -> void:
	draw_circle(
		Vector2.LEFT * 6.0, 3.0, Util.BG_COLOR, true
	)
	draw_circle(
		Vector2.LEFT * 6.0, 1.0, color, true
	)


func _on_hurtbox_hurt(hitbox: Hitbox, damage: int, invinc_time: float) -> void:
	health.hurt(damage)
	
	color = Color.YELLOW
	trail.modulate = color
	await get_tree().create_timer(invinc_time, false).timeout
	color = Color.RED
	trail.modulate = color


func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(knockback)
	apply_torque_impulse(
		360.0 * sign( (global_position + knockback).angle_to(global_position + linear_velocity.normalized()) )
	)
