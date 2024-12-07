class_name EnemyBouncer
extends RigidBody2D

@export var radius: float = 8.0

@export_group("Inner Dependencies")
@export var health: Health

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var tri := Util.generate_polygon(3, radius, true)
	var outline: PackedVector2Array = Util.generate_polygon(
		3, radius + 2.0, true
	)
	draw_colored_polygon(
		outline, Util.BG_COLOR
	)
	draw_polyline(
		tri, Color.RED, 1.0
	)

func _on_hurtbox_hurt(hitbox: Hitbox, damage: int, invinc_time: float) -> void:
	health.hurt(damage)


func _on_health_has_died() -> void:
	queue_free()
