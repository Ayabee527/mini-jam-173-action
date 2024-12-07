extends Node2D

signal enemy_killed(enemy: Node2D)
signal wave_cleared(size: int)

const PLATFORM = preload("res://main/platform/platform.tscn")

const BOUNCER = preload("res://enemies/bouncer.tscn")

const ENEMIES = {
	"BOUNCER": BOUNCER
}

const COSTS = {
	"BOUNCER": 1
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
	#spawn_platforms()
	
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
		enemy.global_position = Vector2(
			randf_range(64.0, 256.0 - 64.0),
			0.0
		)
		if enemy.has_signal("died"):
			enemy.died.connect(kill_enemy.bind(enemy))
		else:
			enemy.tree_exiting.connect(kill_enemy.bind(enemy))
		add_child(enemy)
		await get_tree().create_timer(0.1, false).timeout

func spawn_platforms() -> void:
	for platform in active_platforms:
		platform.leave(5.0)
		await get_tree().create_timer(randf() * 0.2, false).timeout
	active_platforms.clear()
	
	var platform_num: int = randi_range(1, 5)
	for i: int in range(platform_num):
		var y_pos: float = 16.0 + ((i + 1) * 208.0 / platform_num)
		var x_pos: float = 128.0 + randf_range(-96.0, 96.0)
		
		var platform: Platform = PLATFORM.instantiate()
		platform.start_pos = Vector2(x_pos, 256.0)
		platform.global_position = platform.start_pos
		platform.end_pos = Vector2(x_pos, y_pos)
		platform.move_time = randf_range(3.0, 5.0)
		platform.width = randf_range(32.0, 128.0)
		
		add_child(platform)
		active_platforms.append(platform)

func kill_enemy(enemy: Node2D) -> void:
	spawned_enemies.erase(enemy)
	enemy_killed.emit(enemy)
	if spawned_enemies.size() <= 0:
		wave_cleared.emit(wave_size)
		wave += 1
		spawn_wave()
