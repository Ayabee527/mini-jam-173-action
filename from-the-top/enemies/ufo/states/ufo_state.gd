class_name EnemyUFOState
extends State

var enemy: EnemyUFO

func _ready() -> void:
	await owner.ready
	enemy = owner as EnemyUFO
	assert(enemy != null)
