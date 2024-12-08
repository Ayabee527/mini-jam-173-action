class_name EnemyTetherState
extends State

var enemy: EnemyTether

func _ready() -> void:
	await owner.ready
	enemy = owner as EnemyTether
	assert(enemy != null)
