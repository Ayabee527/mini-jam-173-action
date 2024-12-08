extends EnemyTetherState

@export var move_speed: float = 1000.0
@export var turn_speed: float = 2.5

func enter(_msg:={}) -> void:
	enemy.hurt_coll.set_deferred("disabled", true)
	enemy.coll_shape.set_deferred("disabled", true)
	#enemy.trail.emitting = false
	
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
	enemy.apply_central_force(
		Vector2.UP * move_speed
	)

func _on_health_has_died() -> void:
	if not is_active:
		state_machine.transition_to("Die")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_active:
		enemy.queue_free()
