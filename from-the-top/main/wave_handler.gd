extends Node2D

signal enemy_killed(enemy: Node2D)
signal enemy_hurt()
signal wave_cleared(size: int)

const UFO = preload("res://enemies/ufo/ufo.tscn")
const TETHER = preload("res://enemies/tether/tether.tscn")
const VIRUS = preload("res://enemies/virus/virus.tscn")
const TURRET = preload("res://enemies/turret/turret.tscn")

const ENEMIES = {
	"UFO": UFO,
	"TETHER": TETHER,
	"VIRUS": VIRUS,
	"TURRET": TURRET
}

const COSTS = {
	"UFO": 2,
	"TETHER": 4,
	"VIRUS": 2,
	"TURRET": 8
}

@export var active: bool = true
@export var time_before_start: float = 5.0
@export var extra_spend: int = 2

var wave_size: int = 0
var wave: int = 0

var spawned_enemies: Array[Node2D] = []
var active_platforms: Array[Platform] = []

func _ready() -> void:
	if not active:
		return
	
	await get_tree().create_timer(time_before_start, false).timeout
	spawn_wave()

func spawn_wave() -> void:
	var score: int = wave + extra_spend
	
	var chosens: Array = []
	
	var enemies: Array = COSTS.keys().duplicate()
	var score_out: bool = false
	while score > 0:
		enemies = COSTS.keys().duplicate()
		
		enemies.shuffle()
		var chosen_enemy = enemies.pop_back()
		
		while (COSTS[chosen_enemy] > score):
			if enemies.size() == 0:
				score_out = true
				break
			
			chosen_enemy = enemies.pop_back()
		
		if score_out:
			break
		
		score -= COSTS[chosen_enemy]
		
		chosens.append(chosen_enemy)
	
	wave_size = chosens.size()
	
	for name: String in chosens:
		var enemy: Node2D = ENEMIES[name].instantiate()
		spawned_enemies.append(enemy)
		enemy.global_position = (
			Vector2.ONE * 128.0
			+ Vector2.from_angle(TAU * randf()) * 256.0
		)
		if enemy.has_signal("hurt"):
			enemy.hurt.connect(hurt_enemy)
		if enemy.has_signal("died"):
			enemy.died.connect(kill_enemy.bind(enemy))
		else:
			enemy.tree_exiting.connect(kill_enemy.bind(enemy))
		add_child(enemy)
		await get_tree().create_timer(0.1, false).timeout

func hurt_enemy() -> void:
	enemy_hurt.emit()

func kill_enemy(enemy: Node2D) -> void:
	spawned_enemies.erase(enemy)
	enemy_killed.emit(enemy)
	if spawned_enemies.size() <= 0:
		wave_cleared.emit(wave_size)
		wave += 1
		spawn_wave()
