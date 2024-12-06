class_name WeaponHandler
extends Node2D

signal fired()

@export var muzzle_distance: float = 8.0
@export var muzzle_is_origin: bool = true
@export var collision_data: CollisionData

@export var weapons: Array[Weapon]:
	set = set_weapons

@export_group("Inner Dependencies")
@export var flash: GPUParticles2D
@export var muzzle: Marker2D
@export var fire_timer: Timer
@export var burst_timer: Timer
@export var sound: AudioStreamPlayer2D

var firing: bool = false:
	set = set_firing
var weapon_idx: int = 0:
	set = set_weapon_idx

var burst_count: int = 0

func _ready() -> void:
	muzzle.position = Vector2.RIGHT * muzzle_distance

func set_weapon_idx(new_weapon_idx: int) -> void:
	weapon_idx = new_weapon_idx
	burst_count = 0
	if weapons.size() > 0:
		if weapons[weapon_idx] != null:
			update_dazzle(weapons[weapon_idx].attack_data.color)

func set_weapons(new_weapons: Array[Weapon]) -> void:
	weapons = new_weapons
	weapon_idx = 0

func set_firing(new_firing: bool) -> void:
	firing = new_firing
	if firing and fire_timer.is_stopped() and burst_timer.is_stopped():
		shoot()

func shoot() -> void:
	if weapons.size() <= 0:
		return
	
	var weapon: Weapon = weapons[weapon_idx]
	if weapon == null:
		weapon_idx = wrapi(weapon_idx + 1, 0, weapons.size())
		return
	
	if not "attack" in weapon.attack_data:
		weapon_idx = wrapi(weapon_idx + 1, 0, weapons.size())
		return
	
	for i: int in range(weapon.shots_per_shot):
		var attack: Node2D = weapon.attack_data.attack.instantiate() as Node2D
		var attack_data: AttackData = weapon.attack_data.duplicate()
		if "attack_data" in attack:
			attack.attack_data = attack_data
		
		var shoot_angle: float = weapon.rotation_offset + (weapon.angle_per_shot * i)
		
		attack.collision_data = collision_data
		if muzzle_is_origin:
			attack.global_position = muzzle.global_position
		else:
			attack.global_position = (
				global_position
				+ (Vector2.from_angle(global_rotation).rotated(shoot_angle) * muzzle_distance)
			)
		attack.global_rotation = muzzle.global_rotation + weapon.angle_offset
		attack.global_rotation += deg_to_rad(shoot_angle)
		attack.global_rotation += deg_to_rad(
			randf_range(-weapon.spread, weapon.spread)
		)
		
		if weapon.payload:
			attack_data.expired.connect( unleash_payload.bind(attack, weapon.payload) )
			attack_data.trigger_payload.connect( unleash_payload.bind(attack, weapon.payload) )
		
		owner.get_parent().add_child.call_deferred(attack)
	
	sound.stream = weapon.attack_data.sound
	sound.play()
	fired.emit()
	MainCam.shake(weapon.camera_shake_shake, weapon.camera_shake_speed, weapon.camera_shake_decay)
	flash.restart()
	if weapon.shot_cooldown > 0.0:
		fire_timer.start(weapon.shot_cooldown)
	else:
		await get_tree().physics_frame
		if firing:
			shoot()
	
	burst_count += 1
	if burst_count >= weapon.shots_per_burst:
		weapon_idx = wrapi(weapon_idx + 1, 0, weapons.size())
		if weapon.burst_cooldown > 0.0:
			burst_timer.start(weapon.burst_cooldown)

func update_dazzle(color: Color) -> void:
	flash.modulate = color

func unleash_payload(carrier: Node2D, payload: Weapon) -> void:
	if not "attack" in payload.attack_data:
		return
	
	for i: int in range(payload.shots_per_shot):
		var attack: Node2D = payload.attack_data.attack.instantiate() as Node2D
		var attack_data: AttackData = payload.attack_data.duplicate()
		if "attack_data" in attack:
			attack.attack_data = attack_data
		
		var shoot_angle: float = payload.rotation_offset + (payload.angle_per_shot * i)
		
		attack.collision_data = collision_data
		attack.global_position = carrier.global_position
		attack.global_rotation = carrier.global_rotation + payload.angle_offset
		attack.global_rotation += deg_to_rad(shoot_angle)
		attack.global_rotation += deg_to_rad(
			randf_range(-payload.spread, payload.spread)
		)
		
		if payload.payload:
			attack_data.expired.connect( unleash_payload.bind(attack, payload.payload) )
			attack_data.trigger_payload.connect( unleash_payload.bind(attack, payload.payload) )
		
		get_tree().current_scene.add_child(attack)
	
	sound.stream = payload.attack_data.sound
	sound.play()
	MainCam.shake(payload.camera_shake_shake, payload.camera_shake_speed, payload.camera_shake_decay)

func _on_fire_timer_timeout() -> void:
	if firing and burst_timer.is_stopped():
		shoot()


func _on_burst_timer_timeout() -> void:
	if firing:
		shoot()
