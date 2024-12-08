extends EnemyUFOState

@export var chase_speed: float = 300.0
@export var turn_speed: float = 20.0

@export var steering: Marker2D

var offscreen: bool = true

func enter(_msg:={}) -> void:
	await get_tree().process_frame
	steering.look_at(enemy.player.global_position)

func physics_update(delta: float) -> void:
	if offscreen:
		var new_transform = steering.global_transform.looking_at(enemy.player.global_position)
		steering.global_transform = steering.global_transform.interpolate_with(new_transform, turn_speed * delta)
		#if Vector2.from_angle(steering.global_rotation).dot(Vector2.DOWN) >= 0.5:
			#enemy.global_transform = steering.global_transform
	
	if sign(enemy.global_position.x - enemy.player.global_position.x) == sign(
		enemy.linear_velocity.normalized().x
	) and sign(enemy.global_position.y - enemy.player.global_position.y) == sign(
		enemy.linear_velocity.normalized().y
	) and not offscreen:
		var new_transform = steering.global_transform.looking_at(enemy.global_position + Vector2.DOWN)
		steering.global_transform = steering.global_transform.interpolate_with(new_transform, 0.5 * turn_speed * delta)
		if chase_speed != -300.0:
			chase_speed = -300.0
	
	enemy.apply_central_force(
		Vector2.from_angle(steering.global_rotation) * chase_speed
	)
	
	var turn_axis := enemy.linear_velocity.normalized().x
	var turn_transform = enemy.global_transform.looking_at(enemy.global_position + Vector2(turn_axis, 1.0))
	if Vector2.from_angle( turn_transform.get_rotation() ).dot(Vector2.DOWN) >= 0.5:
		enemy.global_transform = enemy.global_transform.interpolate_with(
			turn_transform, 10.0 * delta
		)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_active:
		offscreen = true
		chase_speed = 300.0


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if is_active:
		offscreen = false
