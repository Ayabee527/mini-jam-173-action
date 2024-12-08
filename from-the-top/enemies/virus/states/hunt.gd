extends EnemyVirusState

@export var chase_speed: float = 100.0
@export var turn_speed: float = 5.0

@export var steering: Marker2D

var meteors: Array

var target: Node2D

func enter(_msg:={}) -> void:
	enemy.weapon_handler.firing = true
	target_meteor()

func physics_update(delta: float) -> void:
	enemy.weapon_handler.look_at(enemy.player.global_position)
	
	var new_transform = steering.global_transform.looking_at(enemy.player.global_position)
	steering.global_transform = steering.global_transform.interpolate_with(new_transform, turn_speed * delta)
	
	enemy.apply_central_force(
		Vector2.from_angle(steering.global_rotation) * chase_speed
	)
	
	var turn_axis := enemy.linear_velocity.normalized().x
	var turn_transform = enemy.global_transform.looking_at(enemy.global_position + Vector2(turn_axis, 1.0))
	if Vector2.from_angle( turn_transform.get_rotation() ).dot(Vector2.DOWN) >= 0.5:
		enemy.global_transform = enemy.global_transform.interpolate_with(
			turn_transform, 10.0 * delta
		)

func target_meteor() -> void:
	meteors = get_tree().get_nodes_in_group("meteors")
	if meteors.size() > 0:
		target = meteors.pick_random()
	else:
		target = enemy.player

func exit() -> void:
	enemy.weapon_handler.firing = false

func _on_virus_body_entered(body: Node) -> void:
	#enemy.weapon_handler.shoot()
	target_meteor()
