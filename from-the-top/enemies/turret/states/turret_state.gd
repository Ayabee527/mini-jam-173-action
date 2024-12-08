class_name EnemyTurretState
extends State

var enemy: EnemyTurret

func _ready() -> void:
	await owner.ready
	enemy = owner as EnemyTurret
	assert(enemy != null)
