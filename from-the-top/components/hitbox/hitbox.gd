class_name Hitbox
extends Area2D

signal hit(hurtbox: Hurtbox)

@export var damage: int = 1
@export var damage_cooldown: float = 0.5
@export var knockback_strength: float = 32.0
@export var knockback_skew: Vector2 = Vector2.ZERO

@export var height_based: bool = true
@export var height: float = 0.0
@export var height_radius: float = 0.0

@export_group("Outer Dependencies")
@export var coll_shape: CollisionShape2D


func _on_cool_timer_timeout() -> void:
	pass # Replace with function body.
