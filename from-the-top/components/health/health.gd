class_name Health
extends Node

signal health_changed(new_health: int)
signal was_hurt(new_health: int, amount: int)
signal was_healed(new_health: int, amount: int)
signal has_died()

@export var max_health: int = 5

var dead: bool = false

var health: int:
	set = _change_health,
	get = _get_health

func _ready() -> void:
	reset_health()

func reset_health() -> void:
	self.health = max_health

func _change_health(new_health: int) -> void:
	if not dead:
		health = clampi(new_health, 0, max_health)
		health_changed.emit(health)
		
		if health <= 0:
			has_died.emit()
			dead = true

func _get_health() -> int:
	return health

func get_health_percent() -> float:
	return (float(health) / max_health) * 100.0

func hurt(amount: int) -> void:
	if dead:
		return
	
	self.health -= amount
	was_hurt.emit(self.health, amount)

func heal(amount: int) -> void:
	if dead:
		return
	
	self.health += amount
	was_healed.emit(self.health, amount)
