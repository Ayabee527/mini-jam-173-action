class_name Hurtbox
extends Area2D

signal hurt(hitbox: Hitbox, damage: int, invinc_time: float)
signal knocked_back(knockback: Vector2)

@export var height: float = 0.0
@export var height_radius: float = 0.0
@export var knockback_modifier: float = 3.0

@export_group("Inner Dependencies")
@export var invinc_timer: Timer

var active_hitboxes: Array[Hitbox] = []

func _process(_delta: float) -> void:
	if active_hitboxes.size() > 0:
		if invinc_timer.is_stopped():
			take_damage()

func take_damage() -> void:
	var chosen_hitbox: Hitbox = active_hitboxes.back() as Hitbox
	
	if chosen_hitbox.height_based:
		if not is_in_height_range(chosen_hitbox):
			return
	
	var hit_pos = chosen_hitbox.global_position + Vector2(0, chosen_hitbox.height)
	var hurt_pos = global_position + Vector2(0, height)
	
	var knockback_dir: Vector2 = chosen_hitbox.global_position.direction_to(global_position)
	var knockback: Vector2 = (
		(knockback_dir + chosen_hitbox.knockback_skew).normalized()
		* chosen_hitbox.knockback_strength * knockback_modifier
	)
	knocked_back.emit(knockback)
	
	chosen_hitbox.hit.emit(self)
	hurt.emit(chosen_hitbox, chosen_hitbox.damage, chosen_hitbox.damage_cooldown)
	
	invinc_timer.start(chosen_hitbox.damage_cooldown)

func is_in_height_range(hitbox: Hitbox) -> bool:
	var hit_range: float = height_radius + hitbox.height_radius
	#prints(height, hitbox.height, range)
	
	return abs(height - hitbox.height) <= hit_range

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and not active_hitboxes.has(area) and not area.owner == owner:
		area = area as Hitbox
		active_hitboxes.append(area)


func _on_area_exited(area: Area2D) -> void:
	if area is Hitbox:
		area = area as Hitbox
		active_hitboxes.erase(area)
