class_name ExplosionData
extends AttackData

@export_group("Basics")
@export var attack: PackedScene
@export var radius: float = 32.0
@export var sides: int = 16
@export var expand_time: float = 0.25
@export var sustain_time: float = 0.1
@export var fade_time: float = 0.3
