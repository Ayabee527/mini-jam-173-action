class_name StateMachine
extends Node

signal transitioned(state_name: String)

@export var initial_state: State

@onready var state: State = initial_state

func _ready() -> void:
	await owner.ready
	
	for child in get_children():
		child.state_machine = self
	state.enter()
	state.is_active = true

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return
	
	state.exit()
	state.is_active = false
	state = get_node(target_state_name)
	state.enter(msg)
	state.is_active = true
	emit_signal("transitioned", state.name)
