extends Node2D

const METEOR = preload("res://enemies/meteor/meteor.tscn")

@export var player: Player

func spawn_meteor() -> void:
	var meteor: EnemyMeteor = METEOR.instantiate()
	meteor.global_position = (
		Vector2.ONE * 128.0
		+ Vector2.from_angle(TAU * randf()) * 256.0
	)
	add_child(meteor)
	var dir_to_player: Vector2 = meteor.global_position.direction_to(player.global_position)
	meteor.apply_central_impulse(
		dir_to_player * randf_range(16.0, 96.0)
	)
	meteor.apply_torque_impulse(
		randf_range(-720.0, 720.0)
	)
	meteor.tree_exited.connect(spawn_meteor)

func _on_wave_handler_wave_cleared(size: int) -> void:
	spawn_meteor()
