class_name LightningBolt
extends Node2D

signal expired()

@export_group("Data")
@export var collision_data: CollisionData
@export var attack_data: LightningData

@export_group("Inner Dependencies")
@export var hitbox: Hitbox
@export var bolt: Line2D
@export var shadow: Line2D

var cur_segments: int = 0
var segments: Array[CollisionShape2D]

var target: Node2D = null
var target_dir: Vector2 = Vector2.ZERO

var last_position: Vector2 = Vector2.ZERO

var frames_since_new: int = 0
var frames_since_kill: int = 0

var segments_disabled: int = 0

var hit_width: float

func _ready() -> void:
	bolt.default_color = attack_data.color.lightened(randf_range(0.0, 1.0))
	
	last_position = global_position
	target_dir = Vector2.from_angle(global_rotation)
	
	hitbox.collision_layer = collision_data.collision_layer
	hitbox.collision_mask = collision_data.collision_mask
	hitbox.damage = attack_data.hitbox_data.damage
	hitbox.damage_cooldown = attack_data.hitbox_data.damage_cooldown
	hitbox.knockback_strength = attack_data.hitbox_data.knockback_strength
	
	hit_width = randi_range(attack_data.min_width, attack_data.max_width)
	bolt.width = hit_width
	shadow.width = hit_width
	
	bolt.add_point(last_position)
	shadow.add_point(last_position + attack_data.shadow_offset)
	
	spawn_segment()
	await get_tree().process_frame
	find_target()

func _physics_process(delta: float) -> void:
	bolt.global_rotation = 0
	shadow.global_rotation = 0
	bolt.global_position = Vector2.ZERO
	shadow.global_position = Vector2.ZERO
	
	if segments_disabled < segments.size():
		frames_since_new += 1
	if segments.size() > 0:
		frames_since_kill += 1
	
	if frames_since_new >= (
		attack_data.frames_per_segment
		+ randi_range(-attack_data.frame_inaccuracy, attack_data.frame_inaccuracy)
	):
		frames_since_new = 0
		if cur_segments < attack_data.segments:
			if is_instance_valid(target) and attack_data.homes:
				home_in()
			spawn_segment()
		else:
			attack_data.expired.emit()
	
	if frames_since_kill >= (
		attack_data.sustain_frames
		+ randi_range(-attack_data.frame_inaccuracy, attack_data.frame_inaccuracy)
	):
		frames_since_kill = 0
		if segments_disabled < segments.size():
			var segment: CollisionShape2D = segments[segments_disabled] as CollisionShape2D
			segment.set_deferred("disabled", true)
			bolt.remove_point(0)
			shadow.remove_point(0)
			segments_disabled += 1
		else:
			expired.emit()
			queue_free()

func spawn_segment() -> void:
	cur_segments += 1
	
	var segment_length: float = randf_range(
		attack_data.min_segment_length, attack_data.max_segment_length
	)
	var next_position: Vector2 = (
		last_position
		+ (target_dir * segment_length)
	)
	var normal: Vector2 = target_dir.rotated(90).normalized()
	var offset: float = randf_range(-attack_data.width, attack_data.width)
	next_position += normal * offset
	
	bolt.add_point(next_position)
	shadow.add_point(next_position + attack_data.shadow_offset)
	
	var coll_shape := CollisionShape2D.new()
	var rect_shape := RectangleShape2D.new()
	rect_shape.size = Vector2(
		segment_length * 2.0, hit_width
	)
	coll_shape.global_position = to_local( (last_position + next_position) / 2.0 )
	coll_shape.rotation = to_local(last_position).angle_to_point(to_local(next_position))
	coll_shape.shape = rect_shape
	hitbox.add_child(coll_shape)
	segments.append(coll_shape)
	
	last_position = next_position

func home_in() -> void:
	var dir_to_target: Vector2 = last_position.direction_to(target.global_position)
	var angle_to: float = target_dir.angle_to(dir_to_target)
	var home_turn: float = signf(angle_to) * minf(
		abs(angle_to), abs(deg_to_rad(attack_data.max_home_angle))
	)
	home_turn += deg_to_rad(randf_range(-attack_data.home_inaccuracy, attack_data.home_inaccuracy))
	target_dir = target_dir.rotated(home_turn)

func find_target() -> void:
	if not is_inside_tree():
		return
	
	if not get_tree():
		return
	
	var targets: Array[Node2D] = []
	for group in attack_data.targets:
		targets.append_array(get_tree().get_nodes_in_group(group))
	var closest_dist: float = INF
	var closest_target: Node2D = null
	for c_target: Node2D in targets:
		var dist_to: float = global_position.distance_squared_to(c_target.global_position)
		if dist_to < closest_dist:
			closest_dist = dist_to
			closest_target = c_target
	
	target = closest_target
	if target != null:
		if target.has_signal("died") and not target.is_connected("died", find_target):
			target.died.connect(find_target)
		else:
			if not target.is_connected("tree_exited", find_target):
				target.tree_exited.connect(find_target)
