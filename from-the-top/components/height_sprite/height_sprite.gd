class_name HeightSprite
extends Sprite2D

signal height_changed(new_height: float)
signal ground_hit()
signal bounced()

@export var hurt_color: Color = Color.WHITE
@export var height: float = 0.0:
	set = set_height
@export var bounce: float = 0.0

@export_group("Inner Dependencies")
@export var hurt_player: AnimationPlayer

var jump_velocity : float = 0.0
var jump_gravity : float = 0.0
var fall_gravity : float = 0.0

var speed: float = 0.0

func _ready() -> void:
	await get_tree().physics_frame
	
	var mat: ShaderMaterial = material as ShaderMaterial
	if mat.get_shader_parameter("tint") != hurt_color:
		mat.set_shader_parameter("tint", hurt_color)

func _process(delta: float) -> void:
	height -= speed * delta
	offset = Vector2(0, -height).rotated(-global_rotation)
	
	if height < 1.0 and speed > 0.0:
		speed *= -bounce
		if bounce > 0.0:
			height = max(1.0, height)
		else:
			height = max(0.0, height)
		
		ground_hit.emit()
		if bounce > 0.0 and abs(speed) > 8.0:
			emit_signal("bounced")
	
	if height > 0.0:
		speed += get_gravity() * delta

func set_height(new_height: float) -> void:
	height = new_height
	height_changed.emit(height)

func get_gravity() -> float:
	return jump_gravity if speed < 0.0 else fall_gravity

func jump(jump_height: float, jump_time_to_peak: float, jump_time_to_fall: float) -> void:
	jump_velocity = 0.0
	jump_gravity = 98
	fall_gravity = 98
	
	if jump_time_to_peak == 0.0 and jump_time_to_fall == 0.0:
		return
	
	if jump_time_to_peak > 0.0:
		jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
		jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
		fall_gravity = jump_gravity
	if jump_time_to_fall > 0.0:
		fall_gravity = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0
		if jump_time_to_peak <= 0.0:
			jump_gravity = fall_gravity
	
	if jump_velocity != 0.0:
		speed = jump_velocity
	else:
		speed = 0.0
		height = jump_height

func play_hurt() -> void:
	var mat: ShaderMaterial = material as ShaderMaterial
	if mat.get_shader_parameter("tint") != hurt_color:
		mat.set_shader_parameter("tint", hurt_color)
	
	hurt_player.play("hurt")

func squish(amount: float = 4.0, flat: bool = true, time: float = 0.5) -> void:
	var start_scale: Vector2 = Vector2.ONE
	if flat:
		start_scale = Vector2(amount, 1.0 / amount)
	else:
		start_scale = Vector2(1.0 / amount, amount)
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(
		self, "scale",
		Vector2.ONE, time
	).from(start_scale)
