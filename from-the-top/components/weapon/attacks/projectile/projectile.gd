class_name ProjectileAttack
extends Area2D

@export_group("Data")
@export var collision_data: CollisionData
@export var attack_data: ProjectileData

@export_group("Inner Dependencies")
@export var sprite: HeightSprite
@export var shadow: Shadow
@export var trail_holder: Marker2D
@export var trail: Trail
@export var expire_particles: GPUParticles2D

@export var life_timer: Timer

@export var hitbox: Hitbox
@export var collision: CollisionShape2D
@export var hitbox_collision: CollisionShape2D

var pierces: int = 0

var cur_speed: float = 0.0
var cur_home_speed: float = 0.0
var cur_accel_time: float = 0.0
var cur_home_accel_time: float = 0.0

var velocity: Vector2 = Vector2.ZERO
var target: Node2D

var expired: bool = false

func _ready() -> void:
	sprite.texture = attack_data.texture
	
	sprite.modulate = attack_data.color
	trail.modulate = attack_data.color
	expire_particles.modulate = attack_data.color
	
	trail.visible = attack_data.trail_visible
	
	var shape := CircleShape2D.new()
	shape.radius = attack_data.radius
	collision.shape = shape
	hitbox_collision.shape = shape
	trail.width = (attack_data.radius - 1.0) * 2.0
	
	hitbox.damage = attack_data.hitbox_data.damage
	hitbox.damage_cooldown = attack_data.hitbox_data.damage_cooldown
	hitbox.knockback_strength = attack_data.hitbox_data.knockback_strength
	hitbox.height_radius = attack_data.radius
	
	collision_layer = collision_data.collision_layer
	collision_mask = collision_data.collision_mask
	hitbox.collision_layer = collision_layer
	hitbox.collision_mask = collision_mask
	
	life_timer.start(attack_data.life_time)
	cur_speed = attack_data.start_speed
	
	await get_tree().process_frame
	find_target()

func _physics_process(delta: float) -> void:
	shadow.rotation_degrees += attack_data.spin_speed * delta
	sprite.rotation_degrees += attack_data.spin_speed * delta
	
	if expired:
		return
	
	if is_instance_valid(target) and attack_data.homes:
		home_on_target(delta)
	else:
		global_rotation_degrees += attack_data.turn_speed * delta
	
	if attack_data.accel_time > 0.0:
		cur_speed = lerpf(
			attack_data.start_speed, attack_data.end_speed,
			cur_accel_time / abs(attack_data.accel_time)
		)
	if cur_accel_time < attack_data.accel_time:
		cur_accel_time += delta
		cur_accel_time = min(cur_accel_time, abs(attack_data.accel_time))
	
	if attack_data.home_accel_time > 0.0:
		cur_home_speed = lerpf(
			attack_data.start_home_speed, attack_data.end_home_speed,
			cur_accel_time / abs(attack_data.home_accel_time)
		)
	if cur_home_accel_time < attack_data.home_accel_time:
		cur_home_accel_time += delta
		cur_home_accel_time = min(cur_home_accel_time, abs(attack_data.home_accel_time))
	
	velocity = Vector2.from_angle(global_rotation) * cur_speed
	global_position += velocity * delta

func home_on_target(delta: float) -> void:
	var dir_to_target: Vector2 = global_position.direction_to(target.global_position)
	var angle_to: float = Vector2.from_angle(global_rotation).angle_to(dir_to_target)
	global_rotation_degrees += cur_home_speed * sign(angle_to) * delta

func find_target() -> void:
	if not is_inside_tree():
		return
	
	if not get_tree():
		return
	
	var targets: Array[Node2D] = []
	for group in attack_data.targets:
		targets.append_array(get_tree().get_nodes_in_group(group))
	var closest_dist: float = INF
	var closest_target: Node2D = null
	for c_target: Node2D in targets:
		var dist_to: float = global_position.distance_squared_to(c_target.global_position)
		if dist_to < closest_dist:
			closest_dist = dist_to
			closest_target = c_target
	
	target = closest_target
	if target != null:
		if target.has_signal("died") and not target.is_connected("died", find_target):
			target.died.connect(find_target)
		else:
			if not target.is_connected("tree_exited", find_target):
				target.tree_exited.connect(find_target)

func expire() -> void:
	if expired:
		return
	
	attack_data.expired.emit()
	expired = true
	
	expire_particles.restart()
	shadow.hide()
	sprite.hide()
	
	hitbox_collision.set_deferred("disabled", true)
	
	await expire_particles.finished
	queue_free()

func _on_life_timer_timeout() -> void:
	expire()

func _on_hitbox_hit(_hurtbox: Hurtbox) -> void:
	pierces += 1
	
	if pierces > attack_data.max_pierces:
		expire()


func _on_sprite_height_changed(_new_height: float) -> void:
	trail_holder.position = sprite.offset
	collision.position = sprite.offset
