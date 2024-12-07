extends PlayerState

func enter(_msg:={}) -> void:
	pass

func physics_update(delta: float) -> void:
	player.apply_central_force(
		Vector2.RIGHT * player.get_move_axis() * player.move_speed
	)
	
	if player.grapple_detect.is_colliding():
		player.grapple_point = player.grapple_detect.get_collision_point()
	else:
		player.grapple_point = Vector2.ZERO
	
	if Input.is_action_just_pressed("attack") and player.grapple_detect.is_colliding():
		state_machine.transition_to("Hook")
	
	if Input.is_action_just_pressed("jump") and player.floor_detect.is_colliding():
		player.apply_central_impulse(
			Vector2.UP * 200.0
		)
