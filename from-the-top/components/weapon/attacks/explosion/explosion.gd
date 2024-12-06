class_name ExplosionAttack
extends Node2D

@export_group("Data")
@export var collision_data: CollisionData
@export var attack_data: ExplosionData

@export_group("Inner Dependencies")
@export var outline: Line2D
@export var hitbox: Hitbox
@export var hitbox_collision: CollisionShape2D
@export var sustain_timer: Timer
@export var debri: GPUParticles2D

func _ready() -> void:
	global_rotation = 0
	
	var offset: float = attack_data.radius / 4.0
	var points := PackedVector2Array()
	for i: int in range(attack_data.sides):
		var ang = (float(i) / attack_data.sides) * TAU
		var point = Vector2.from_angle(ang) * attack_data.radius
		points.append(point)
	outline.points = points
	
	outline.default_color = attack_data.color
	debri.modulate = attack_data.color
	
	hitbox.damage = attack_data.hitbox_data.damage
	hitbox.damage_cooldown = attack_data.hitbox_data.damage_cooldown
	hitbox.knockback_strength = attack_data.hitbox_data.knockback_strength
	
	var col_shape = CircleShape2D.new()
	col_shape.radius = attack_data.radius
	hitbox_collision.shape = col_shape
	
	hitbox.collision_layer = collision_data.collision_layer
	hitbox.collision_mask = collision_data.collision_mask
	
	debri.restart()
	expand()
	sustain_timer.start(attack_data.sustain_time)

func expand() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		hitbox, "scale",
		Vector2.ONE, attack_data.expand_time
	).from(Vector2.ZERO)
	tween.tween_property(
		outline, "scale",
		Vector2.ONE, attack_data.expand_time
	).from(Vector2.ZERO)
	tween.tween_property(
		outline, "width",
		4.0, attack_data.expand_time
	).from(0.0)
	tween.play()
	
	await get_tree().physics_frame
	hitbox_collision.set_deferred("disabled", false)

func fade() -> void:
	hitbox_collision.set_deferred("disabled", true)
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		outline, "width",
		0.0, attack_data.expand_time
	).from(4.0)
	tween.play()
	
	await tween.finished
	attack_data.expired.emit()
	queue_free()


func _on_sustain_timer_timeout() -> void:
	fade()
