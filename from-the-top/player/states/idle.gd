extends PlayerState

func physics_update(_delta: float) -> void:
	if player.get_move_vector():
		state_machine.transition_to("Move")
