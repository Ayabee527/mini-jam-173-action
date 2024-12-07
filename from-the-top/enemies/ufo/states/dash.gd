extends EnemyUFOState

@export var chase_speed: float = 500.0
@export var turn_speed: float = 20.0

@export var steering: Marker2D

var offscreen: bool = false

func enter(_msg:={}) -> void:
	enemy.look_at(enemy.player.global_position)

func physics_update(delta: float) -> void:
	if offscreen:
		var new_transform = steering.global_transform.looking_at(enemy.player.global_position)
		steering.global_transform = steering.global_transform.interpolate_with(new_transform, turn_speed * delta)
		if Vector2.from_angle(steering.global_rotation).dot(Vector2.DOWN) > 0.5:
			enemy.global_transform = steering.global_transform
	
	enemy.apply_central_force(
		Vector2.from_angle(steering.global_rotation) * chase_speed
	)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_active:
		offscreen = true


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if is_active:
		offscreen = false
