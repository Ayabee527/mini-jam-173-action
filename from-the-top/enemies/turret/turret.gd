class_name EnemyTurret
extends RigidBody2D

signal died()
signal hurt()

@export var radius: float = 16.0

@export_group("Inner Dependencies")
@export var coll_shape: CollisionShape2D
@export var hurt_coll: CollisionShape2D
@export var hit_coll: CollisionShape2D
@export var trail: GPUParticles2D
@export var health: Health
@export var hurt_sound: AudioStreamPlayer
@export var die_sound: AudioStreamPlayer
@export var weapon_handler: WeaponHandler

var player: Player

var color: Color = Color.RED
var draw_scale: float = 1.0

func _ready() -> void:
	var coll := CircleShape2D.new()
	coll.radius = radius
	coll_shape.shape = coll
	hurt_coll.shape = coll
	hit_coll.shape = coll
	
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	queue_redraw()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = state.linear_velocity.limit_length(50.0)

func _draw() -> void:
	draw_shape()

func draw_shape() -> void:
	draw_circle(
		Vector2.ZERO, radius + 2.0, Util.BG_COLOR, true
	)
	draw_circle(
		Vector2.ZERO, radius, color, false, 1.0
	)

func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(knockback)


func _on_hurtbox_hurt(hitbox: Hitbox, damage: int, invinc_time: float) -> void:
	health.hurt(damage)
	hurt_sound.play()
	hurt.emit()
	
	color = Color.YELLOW
	trail.modulate = color
	await get_tree().create_timer(invinc_time, false).timeout
	color = Color.RED
	trail.modulate = color
