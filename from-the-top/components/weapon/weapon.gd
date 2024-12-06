class_name Weapon
extends Resource

@export var attack_data: AttackData
@export var spread: float = 0.0
@export var rotation_offset: float = 0.0
@export var shots_per_shot: int = 1
@export var shots_per_burst: int = 1
@export var angle_per_shot: float = 0.0
@export var angle_offset: float = 0.0
@export var shot_cooldown: float = 0.1
@export var burst_cooldown: float = 0.0
@export var camera_shake_shake: float = 5
@export var camera_shake_speed: float = 15
@export var camera_shake_decay: float = 15
@export var payload: Weapon
