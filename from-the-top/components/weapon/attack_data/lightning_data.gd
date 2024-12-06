class_name LightningData
extends AttackData

@export_group("Basics")
@export var attack: PackedScene
@export var width: float = 8.0
@export var bolts: int = 3
@export var segments: int = 10
@export var frames_per_segment: int = 3.0
@export var sustain_frames: int = 6.0
@export var frame_inaccuracy: int = 1
@export var min_segment_length: float = 8.0
@export var max_segment_length: float = 12.0

@export_group("Homing")
@export var homes: bool = true
@export var targets: Array[String] = ["conductors"]
@export var max_home_angle: float = 15.0
@export var home_inaccuracy: float = 5.0

@export_group("Graphics")
@export var shadow_offset: Vector2 = Vector2(-2, 2)
@export var min_width: float = 1.0
@export var max_width: float = 2.0
