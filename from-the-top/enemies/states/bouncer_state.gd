class_name EnemyBouncerState
extends State

var enemy: EnemyBouncer

func _ready() -> void:
	await owner.ready
	enemy = owner as EnemyBouncer
	assert(enemy != null)
