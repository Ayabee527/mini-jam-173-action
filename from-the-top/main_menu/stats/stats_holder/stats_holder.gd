class_name StatsHolder
extends HBoxContainer

@export var place: String = "1.":
	set = set_place
@export var score: String = "000000":
	set = set_score

@export var place_label: RichTextLabel
@export var score_label: RichTextLabel

func _ready() -> void:
	place_label.text = "[wave]" + place
	score_label.text = "[wave]" + score

func set_place(new_place: String) -> void:
	place = new_place
	
	place_label.text = "[wave]" + place

func set_score(new_score: String) -> void:
	score = new_score
	
	score_label.text = "[wave]" + score
