extends Area2D

@export var radius: float = 64.0

@export_group("Inner Dependencies")
@export var coll_shape: CollisionShape2D

@export_group("Outer Dependencies")
@export var weapon_handler: WeaponHandler

var enemies_in_range: Array[Node2D]

var target: Node2D
var disabled: bool = false

func _ready() -> void:
	var coll = CircleShape2D.new()
	coll.radius = radius
	coll_shape.shape = coll

func _process(delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	if target != null:
		weapon_handler.look_at(target.global_position)

func _draw() -> void:
	return
	
	draw_circle(
		Vector2.ZERO, radius - 2.0, Color(0.25, 0.25, 0.25, 0.1), true
	)
	var out_color := Util.BORDER_COLOR
	out_color.a = 0.25
	draw_circle(
		Vector2.ZERO, radius, out_color, false, 1.0
	)


func _on_body_entered(body: Node2D) -> void:
	if disabled:
		return
	
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)
		reprioritize()
		
		if not weapon_handler.firing:
			weapon_handler.firing = true


func _on_body_exited(body: Node2D) -> void:
	if disabled:
		return
	
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)
		
		if enemies_in_range.size() == 0:
			weapon_handler.firing = false

func reprioritize() -> void:
	var closest_target: Node2D
	var closest_dist: float
	for enemy: Node2D in enemies_in_range:
		var dist = global_position.distance_squared_to(enemy.global_position)
		if dist > closest_dist:
			closest_dist = dist
			closest_target = enemy
	
	target = closest_target

func _on_priority_check_timeout() -> void:
	reprioritize()


func _on_health_has_died() -> void:
	disabled = true
	weapon_handler.firing = false
