extends EnemyBouncerState

@export var chase_speed: float = 150.0
@export var turn_speed: float = 20.0

func physics_update(delta: float) -> void:
	var new_transform = enemy.transform.looking_at(enemy.player.global_position)
	enemy.transform = enemy.transform.interpolate_with(new_transform, turn_speed * delta)
	
	enemy.apply_central_force(
		Vector2.from_angle(enemy.global_rotation) * chase_speed
	)
