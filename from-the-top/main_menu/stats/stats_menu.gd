class_name StatsMenu
extends PanelContainer

signal back()

const STATS_HOLDER = preload("res://main_menu/stats/stats_holder/stats_holder.tscn")

@export var endless_latest_holder: StatsHolder
@export var endless_highscore_holder: VBoxContainer
@export var back_butt: Button

func _ready() -> void:
	await owner.ready
	initialize()

func initialize() -> void:
	load_endless()

func load_endless() -> void:
	var latest_score = Global.latest_endless_score
	
	endless_latest_holder.place = "Latest:"
	endless_latest_holder.score = biggen_score(latest_score)
	
	for child in endless_highscore_holder.get_children():
		child.queue_free()
	
	for i: int in Global.endless_highscores.size():
		var score = Global.endless_highscores[i]
		
		var holder = STATS_HOLDER.instantiate()
		holder.place = str(i + 1) + "."
		holder.score = biggen_score(score)
		endless_highscore_holder.add_child(holder)

func biggen_score(score: int) -> String:
	var total_digits = 6
	var missing_digits = total_digits - str(score).length()
	
	if missing_digits < 1:
		return str(score)
	
	var biggened_score := ""
	for digit in missing_digits:
		biggened_score += "0"
	biggened_score += str(score)
	
	return biggened_score

func get_time_text(time: int) -> String:
	var text: String = "00:00"
	
	var minutes: int = 0
	var seconds: int = 0
	
	seconds = time % 60
	minutes = time / 60
	
	var minute_text: String = "00"
	if minutes < 10:
		minute_text = "0" + str(minutes)
	else:
		minute_text = str(minutes)
	
	var second_text: String = "00"
	if seconds < 10:
		second_text = "0" + str(seconds)
	else:
		second_text = str(seconds)
	
	text = minute_text + ":" + second_text
	
	return text


func _on_back_pressed() -> void:
	back.emit()


func _on_visibility_changed() -> void:
	if visible:
		back_butt.grab_focus()
		initialize()
