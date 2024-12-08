extends EnemyTetherState

@export var move_speed: float = 2048.0

var target_point: Vector2 = Vector2(128.0, 128.0)

func enter(_msg:={}) -> void:
	target_point = Vector2(
		randf_range(64.0, 192.0),
		randf_range(64.0, 192.0)
	)

func physics_update(_delta: float) -> void:
	var dist_to_target := enemy.global_position.distance_to(target_point)
	var dir_to_target := enemy.global_position.direction_to(target_point)
	
	enemy.apply_central_force(
		dir_to_target * move_speed
	)
	
	#print(dist_to_target)
	if dist_to_target <= 32.0:
		state_machine.transition_to("Tether")

func exit() -> void:
	pass
