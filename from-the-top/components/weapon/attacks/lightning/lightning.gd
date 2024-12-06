class_name LightningAttack
extends Node2D

const BOLT: PackedScene = preload("res://components/weapon/attacks/lightning/lightning_bolt.tscn")

@export_group("Data")
@export var collision_data: CollisionData
@export var attack_data: LightningData

var expired_bolts: int = 0

func _ready() -> void:
	for i: int in range(attack_data.bolts):
		var bolt: LightningBolt = BOLT.instantiate()
		bolt.collision_data = collision_data
		bolt.attack_data = attack_data
		bolt.global_position = Vector2.ZERO
		bolt.global_rotation = 0
		bolt.expired.connect(expire_bolt)
		add_child(bolt)

func expire_bolt() -> void:
	expired_bolts += 1
	
	if expired_bolts >= attack_data.bolts:
		queue_free()
