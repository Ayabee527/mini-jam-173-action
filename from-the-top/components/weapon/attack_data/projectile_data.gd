class_name ProjectileData
extends AttackData

@export_group("Basics")
@export var attack: PackedScene
@export var life_time: float = 2.0
@export var start_speed: float = 384.0
@export var end_speed: float = 384.0
@export var accel_time: float = 0.0
@export var turn_speed: float = 0.0
@export var spin_speed: float = 0.0
@export var radius: float = 3.0
@export var max_pierces: float = 0

@export_group("Homing")
@export var homes: bool = false
@export var targets: Array[String] = ["player"]
@export var start_home_speed: float = 360.0
@export var end_home_speed: float = 360.0
@export var home_accel_time: float = 0.0

@export_group("Graphics")
@export var texture: Texture2D
@export var trail_visible: bool = true
