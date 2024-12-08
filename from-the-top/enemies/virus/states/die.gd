extends EnemyVirusState

@export var burst: GPUParticles2D

@export var move_speed: float = 500.0
@export var turn_speed: float = 2.5

func enter(_msg:={}) -> void:
	enemy.hurt_coll.set_deferred("disabled", true)
	enemy.coll_shape.set_deferred("disabled", true)
	#enemy.trail.emitting = false
	
	enemy.apply_central_impulse(
		Vector2.from_angle(TAU * randf()) * 500.0
	)
	burst.restart()
	enemy.die_sound.play()
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		enemy.trail, "modulate", Color.DIM_GRAY, 1.0
	)
	tween.tween_property(
		enemy, "color", Color.DIM_GRAY, 1.0
	)
	enemy.died.emit()

func physics_update(delta: float) -> void:
	var new_transform = enemy.transform.looking_at(
		Vector2(enemy.global_position.x, 512.0)
	)
	enemy.transform = enemy.transform.interpolate_with(new_transform, turn_speed * delta)
	
	if abs(enemy.global_rotation - PI/2) < PI/12:
		enemy.apply_central_force(
			Vector2.from_angle(enemy.global_rotation) * -move_speed
		)

func _on_health_has_died() -> void:
	if not is_active:
		state_machine.transition_to("Die")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_active:
		enemy.queue_free()
