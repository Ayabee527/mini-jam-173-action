class_name Player
extends RigidBody2D

@export var move_speed: float = 500.0
@export var max_speed: float = 150.0

@export var sides: int = 3
@export var radius: float = 4.0

@export_group("Inner Dependencies")
@export var coll_shape: CollisionShape2D
@export var health: Health
@export var hurt_coll: CollisionShape2D
@export var trail: GPUParticles2D
@export var smoke: GPUParticles2D
@export var hurt_sound: AudioStreamPlayer
@export var die_sound: AudioStreamPlayer

var grapple_point: Vector2

var dashing: bool = false
var intro: bool = true

func _ready() -> void:
	await get_tree().create_timer(0.75, false).timeout
	intro = false
	coll_shape.set_deferred("disabled", false)

func _process(delta: float) -> void:
	queue_redraw()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not dashing:
		state.linear_velocity = state.linear_velocity.limit_length(max_speed)

func _physics_process(delta: float) -> void:
	if intro:
		apply_central_force(
			Vector2.DOWN * move_speed
		)

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

func get_move_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _on_hurtbox_hurt(hitbox: Hitbox, damage: int, invinc_time: float) -> void:
	MainCam.shake(10.0, 10.0, 5.0)
	MainCam.hitstop(0.05, 0.5)
	hurt_sound.play()
	
	health.hurt(damage)
	trail.amount_ratio = health.get_health_percent() / 100.0
	smoke.amount_ratio = 1.0 - (health.get_health_percent() / 100.0)


func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(knockback)
