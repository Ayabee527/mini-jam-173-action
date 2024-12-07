extends PlayerState

@export var turn_speed: float = 5.0

func physics_update(delta: float) -> void:
	var new_transform = player.global_transform.looking_at(player.global_position + Vector2.DOWN)
	player.global_transform = player.global_transform.interpolate_with(new_transform, turn_speed * delta)
	
	if player.get_move_vector():
		state_machine.transition_to("Move")
