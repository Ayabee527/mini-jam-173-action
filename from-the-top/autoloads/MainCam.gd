extends Camera2D

signal hitstop_started()
signal hitstop_done()

@export var zoom_factor: float = 1.0:
	set = set_zoom_factor
@export var default_shake_speed: float = 15.0
@export var default_shake_strength: float = 4.0
@export var default_decay_rate: float = 5.0
@export var min_shake_stength: float = 1.0

var noise_i: float = 0.0
var shake_strength: float = 1.0
var shake_speed: float = 15.0
var shake_decay_rate: float = 5.0

var target: Node2D

var hitstopped: bool = false

@onready var rng := RandomNumberGenerator.new()
@onready var noise := FastNoiseLite.new()

func _ready() -> void:
	rng.randomize()
	noise.seed = rng.randi()
	noise.frequency = 2.0

func _process(delta: float) -> void:
	if is_instance_valid(target):
		global_position = target.global_position
	
	shake_strength = lerp(shake_strength, min_shake_stength, shake_decay_rate * delta)
	offset = get_noise_offset(delta)

func shake(strength: float, speed: float, decay: float) -> void:
	shake_strength = max(strength, shake_strength)
	shake_speed = speed
	shake_decay_rate = decay

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * shake_speed
	
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength,
	)

func hitstop(time_scale: float, duration : float) -> void:
	if hitstopped:
		return
	
	Engine.time_scale = time_scale
	hitstop_started.emit()
	hitstopped = true
	await get_tree().create_timer(duration * time_scale, false).timeout
	Engine.time_scale = 1
	hitstop_done.emit()
	hitstopped = false

func set_zoom_factor(new_zoom_factor: float) -> void:
	zoom_factor = new_zoom_factor
	zoom = Vector2.ONE * zoom_factor
