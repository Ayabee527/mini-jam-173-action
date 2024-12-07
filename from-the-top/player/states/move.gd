extends PlayerState

@export var turn_speed: float = 5.0

func physics_update(delta: float) -> void:
	var move_dir := player.get_move_vector()
	
	var turn_axis := move_dir.x
	var new_transform = player.global_transform.looking_at(player.global_position + Vector2(turn_axis, 1.0))
	if Vector2.from_angle(
			new_transform.get_rotation()
		).dot(Vector2.DOWN) > 0.5:
		player.global_transform = player.global_transform.interpolate_with(new_transform, turn_speed * delta)
	
	player.apply_central_force(
		move_dir * player.move_speed
	)
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	
	if not move_dir:
		state_machine.transition_to("Idle")
