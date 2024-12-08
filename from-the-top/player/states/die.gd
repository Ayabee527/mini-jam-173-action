extends PlayerState

@export var burst: GPUParticles2D

var speed: float = 0.0

func enter(_msg:={}) -> void:
	player.die_sound.play()
	burst.restart()
	player.coll_shape.set_deferred("disabled", true)
	player.hurt_coll.set_deferred("disabled", true)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		self, "speed", -100.0, 5.0
	).from(25.0)

func physics_update(delta: float) -> void:
	var new_transform = player.global_transform.looking_at(player.global_position + Vector2.DOWN)
	player.global_transform = player.global_transform.interpolate_with(new_transform, 5.0 * delta)
	
	player.apply_central_force(
		Vector2.DOWN * speed
	)

func _on_health_has_died() -> void:
	if not is_active:
		state_machine.transition_to("Die")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_active and player.global_position.y < 128.0:
		SceneSwitcher.switch_to("res://main/death/death_scene.tscn")
