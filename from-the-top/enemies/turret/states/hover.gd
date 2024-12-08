extends EnemyTurretState

@export var move_speed: float = 1024.0
@export var hover_timer: Timer

var target_point: Vector2 = Vector2(128.0, 128.0)

func enter(_msg:={}) -> void:
	target_point = Vector2(
		randf_range(64.0, 192.0),
		randf_range(64.0, 192.0)
	)
	enemy.weapon_handler.firing = true
	hover_timer.start()

func physics_update(_delta: float) -> void:
	enemy.weapon_handler.look_at(enemy.player.global_position)
	var dir_to_target := enemy.global_position.direction_to(target_point)
	
	enemy.apply_central_force(
		dir_to_target * move_speed
	)

func exit() -> void:
	enemy.weapon_handler.firing = false


func _on_hover_timer_timeout() -> void:
	target_point = Vector2(
		randf_range(64.0, 192.0),
		randf_range(64.0, 192.0)
	)
