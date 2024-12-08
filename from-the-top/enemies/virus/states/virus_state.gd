class_name EnemyVirusState
extends State

var enemy: EnemyVirus

func _ready() -> void:
	await owner.ready
	enemy = owner as EnemyVirus
	assert(enemy != null)
