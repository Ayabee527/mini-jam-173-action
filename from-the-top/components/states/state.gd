class_name State
extends Node

var state_machine: StateMachine = null

var is_active: bool = false

func handle_input(_event: InputEvent) -> void:
	pass

func enter(_msg := {}) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
