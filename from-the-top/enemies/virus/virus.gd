class_name EnemyVirus
extends RigidBody2D

signal died()

@export var sides: int = 3.0
@export var radius: float = 4.0
@export var spin_time: float = 1.0

@export_group("Inner Dependencies")
@export var coll_shape: CollisionShape2D
@export var hurt_coll: CollisionShape2D
@export var trail: GPUParticles2D
@export var health: Health
@export var hurt_sound: AudioStreamPlayer
@export var die_sound: AudioStreamPlayer
@export var weapon_handler: WeaponHandler

var player: Player

var color: Color = Color.RED
var draw_scale: float = 1.0

var spin: float = 0.0

var prepping: bool = true

func _ready() -> void:
	var coll := CircleShape2D.new()
	coll.radius = radius
	coll_shape.shape = coll
	var hurt_shape := CircleShape2D.new()
	hurt_shape.radius = radius + 2.0
	hurt_coll.shape = hurt_shape
	
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	queue_redraw()
	
	spin += delta
	spin = fposmod(spin, spin_time)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = state.linear_velocity.limit_length(300.0)

func _draw() -> void:
	draw_shape()

func draw_shape() -> void:
	draw_set_transform(Vector2.ZERO, TAU * spin / spin_time, Vector2.ONE * draw_scale)
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
	
	draw_set_transform(Vector2.ZERO, -TAU * spin / spin_time, Vector2.ONE * draw_scale)
	draw_colored_polygon(
		outline, Util.BG_COLOR
	)
	draw_polyline(
		shape, color, 1.0
	)

func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(knockback)


func _on_hurtbox_hurt(hitbox: Hitbox, damage: int, invinc_time: float) -> void:
	health.hurt(damage)
	hurt_sound.play()
	
	color = Color.YELLOW
	trail.modulate = color
	await get_tree().create_timer(invinc_time, false).timeout
	color = Color.RED
	trail.modulate = color
