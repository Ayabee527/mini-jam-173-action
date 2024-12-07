extends PlayerState

@export var grapple_line: Line2D

func enter(_msg:={}) -> void:
	player.linear_velocity = Vector2.ZERO
	player.grapple_point = player.grapple_detect.get_collision_point()
	player.gravity_scale = 0.0
	player.physics_material_override.bounce = 5.0
	MainCam.shake(5.0, 10.0, 3.0)

func physics_update(delta: float) -> void:
	var dir_to_grapple_point = player.global_position.direction_to(player.grapple_point)
	
	player.apply_central_force(
		dir_to_grapple_point * player.grapple_speed
	)
	
	grapple_line.global_position = Vector2.ZERO
	grapple_line.global_rotation = 0
	grapple_line.clear_points()
	grapple_line.add_point(player.global_position)
	grapple_line.add_point(player.grapple_point)
	
	var dist_to_grapple_point = player.global_position.distance_to(
		player.grapple_point
	)
	if dist_to_grapple_point <= 8.0:
		state_machine.transition_to("Move")
	
	if Input.is_action_just_released("attack"):
		state_machine.transition_to("Move")

func exit() -> void:
	player.gravity_scale = 1.0
	grapple_line.clear_points()
