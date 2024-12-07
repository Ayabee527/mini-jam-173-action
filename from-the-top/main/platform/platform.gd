class_name Platform
extends AnimatableBody2D

@export var width: float = 64.0
@export var start_pos: Vector2 = Vector2(128.0, 0.0)
@export var end_pos: Vector2 = Vector2(128.0, 192.0)
@export var move_time: float = 3.0

@export_group("Inner Dependencies")
@export var shape: Polygon2D
@export var coll_shape: CollisionShape2D
@export var collapse: GPUParticles2D

var shape_points: PackedVector2Array
var shape_rect: Rect2

var height: float = 2.0

func _ready() -> void:
	generate_shape()
	
	global_position = start_pos
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(
		self, "global_position", end_pos, move_time
	)

func generate_shape() -> void:
	shape_points.append(Vector2(
		-width / 2.0, -height / 2.0
	))
	shape_points.append(Vector2(
		width / 2.0, -height / 2.0
	))
	shape_points.append(Vector2(
		width / 2.0, height / 2.0
	))
	shape_points.append(Vector2(
		-width / 2.0, height / 2.0
	))
	
	collapse.process_material.emission_box_extents.x = width / 2.0
	
	shape_rect.position = Vector2(-width / 2.0, -height / 2.0)
	shape_rect.size = Vector2(width, height)
	shape.polygon = shape_points
	
	var coll := RectangleShape2D.new()
	coll.size = Vector2(width, height)
	coll_shape.shape = coll

func leave(leave_time: float = 3.0) -> void:
	collapse.restart()
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(
		self, "global_position:y", 256.0, leave_time
	)
	await tween.finished
	queue_free()
