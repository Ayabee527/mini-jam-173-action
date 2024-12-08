extends Node

#const LEADERBOARD_API = "97LLX6KMs11oHRJNs7waM1Z7kY9mtEDD1EXe6d2j"
#const LEADERBOARD_ID = "stardustcrusader"

const MAX_HIGHSCORES = 5

var username: String = ""
var online_prompted: bool = false
var latest_endless_score: int = 0

var endless_highscores: Array[int] = [0, 0, 0, 0, 0]

func _ready():
	SilentWolf.configure({
		"api_key": "97LLX6KMs11oHRJNs7waM1Z7kY9mtEDD1EXe6d2j",
		"game_id": "stardustcrusader",
		"log_level": 1
	})

func save_endless_score(new_score: int) -> void:
	latest_endless_score = new_score
	endless_highscores.append(latest_endless_score)
	
	order_endless_highscores()
	
	if not username.is_empty():
		SilentWolf.Scores.save_score(
			username, latest_endless_score, "endless_weekly"
		)
	
	SaveHandler.save_key("latest_endless_score", latest_endless_score)
	SaveHandler.save_key("endless_highscores", endless_highscores)

func order_endless_highscores() -> void:
	var sort_descend = func(a, b):
		if a > b:
			return true
		else:
			return false
	
	if endless_highscores.size() > MAX_HIGHSCORES:
		endless_highscores.sort_custom(sort_descend)
		while endless_highscores.size() > MAX_HIGHSCORES:
			endless_highscores.pop_back()
	
	if not username.is_empty():
		SilentWolf.Scores.save_score(
			username, endless_highscores[0], "main"
		)
