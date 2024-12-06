class_name Shadow
extends Sprite2D

@export var caster: HeightSprite:
	set = set_caster
@export var shadow_offset: Vector2 = Vector2(-4, 4)
@export var shadow_scale: Vector2 = Vector2.ONE
@export var max_height: float = 128.0

var height_scale: float = 1.0

func _process(_delta: float) -> void:
	offset = shadow_offset.rotated(-global_rotation)
	
	if is_instance_valid(caster):
		height_scale = max(
			0, (1 - (caster.height / max_height))
		)
	
	scale = shadow_scale * height_scale

func set_caster(new_caster: HeightSprite) -> void:
	caster = new_caster
	texture = caster.texture
	caster.frame_changed.connect(update_frame)
	caster.texture_changed.connect(update_texture)

func update_frame() -> void:
	frame = caster.frame

func update_texture() -> void:
	texture = caster.texture
