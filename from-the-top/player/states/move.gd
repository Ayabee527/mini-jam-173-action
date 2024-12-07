extends PlayerState

func physics_update(_delta: float) -> void:
	var move_dir := player.get_move_vector()
	
	player.apply_central_force(
		move_dir * player.move_speed
	)
	
	if not move_dir:
		state_machine.transition_to("Idle")
