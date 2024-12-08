class_name KeybindButton
extends Button

signal waiting()
signal accepted()

@export var input_action: String = ""

var wait: bool = false

func _ready() -> void:
	update_text()

func _unhandled_input(event: InputEvent) -> void:
	if wait:
		if Input.is_action_just_pressed("pause"):
			wait = false
			emit_signal("accepted")
			accepted.emit()
			return
		if event is InputEventKey or event is InputEventMouseButton:
			var all_events: Dictionary = {}
			for action in InputMap.get_actions():
				for action_event in InputMap.action_get_events(action):
					all_events[action_event.as_text()] = action
			
			if all_events.keys().has(event.as_text()):
				InputMap.action_erase_events(all_events[event.as_text()])
			
			InputMap.action_erase_events(input_action)
			InputMap.action_add_event(input_action, event)
			update_text()
			wait = false
			accepted.emit()
			return

func _on_pressed() -> void:
	if not wait:
		wait = true
		waiting.emit()

func update_text() -> void:
	if InputMap.action_get_events(input_action).size() > 0:
		text = InputMap.action_get_events(input_action)[0].as_text()
	else:
		text = "BLANK"
