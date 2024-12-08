extends EnemyTetherState

@export var tether_line: Line2D

@export var pull_speed: float = 200.0

func enter(_msg:={}) -> void:
	enemy.linear_velocity *= 0.25
	enemy.hurt_coll.set_deferred("disabled", false)
	enemy.prepping = false
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.set_parallel()
	tween.tween_property(
		enemy, "draw_scale", 1.0, 1.0
	).from(0.0)
	tween.tween_property(
		tether_line, "modulate:a", 1.0, 1.0
	).from(0.0)
	tween.tween_property(
		enemy, "color", Color.RED, 1.0
	).from(Color.YELLOW)
	await tween.finished
	enemy.trail.show()
	enemy.streak.hide()

func physics_update(delta: float) -> void:
	tether_line.global_position = Vector2.ZERO
	tether_line.global_rotation = 0.0
	tether_line.clear_points()
	tether_line.add_point(enemy.global_position)
	tether_line.add_point(enemy.player.global_position)
	
	var dir_from_player := enemy.player.global_position.direction_to(enemy.global_position)
	enemy.player.apply_central_force(
		dir_from_player * pull_speed 
	)

func exit() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(
		tether_line, "modulate:a", 0.0, 1.0
	).from(1.0)
