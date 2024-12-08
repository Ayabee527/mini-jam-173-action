extends Control

@export var username_input: LineEdit
@export var status: RichTextLabel
@export var confirm_butt: Button

@export var yay_sound: AudioStreamPlayer
@export var nuh_sound: AudioStreamPlayer

var all_good: bool = false

func _ready() -> void:
	MainCam.min_shake_stength = 0.0

func update_status(text: String, color: String) -> void:
	status.text = "[center][wave][color=" + color + "]" + text

func check_status(username: String) -> void:
	update_status("[wave]PROCESSING...", "gray")
	if username.is_empty():
		Global.username = ""
		SaveHandler.save_key("username", Global.username)
		update_status("NOT SIGNED IN...", "gray")
		username_input.clear()
		all_good = true
		return
	
	var user_exists = await is_user_real(username)
	print("User Exists?: ", user_exists)
	if user_exists:
		Global.username = ""
		SaveHandler.save_key("username", Global.username)
		update_status("NAME TAKEN!", "red")
		username_input.clear()
		all_good = false
		nuh_sound.play()
		MainCam.shake(5.0, 10.0, 5.0)
	else:
		Global.username = username
		SaveHandler.save_key("username", Global.username)
		
		await SilentWolf.Scores.save_score(
			Global.username, Global.endless_highscores[0], "main"
		).sw_save_score_complete
		
		await SilentWolf.Scores.save_score(
			Global.username, Global.latest_endless_score, "endless_weekly"
		).sw_save_score_complete
		
		update_status("SIGNED IN!", "lime")
		all_good = true
		yay_sound.play()

func is_user_real(username: String) -> bool:
	var exists: bool = false
	
	var endless_results = await SilentWolf.Scores.get_scores_by_player(
		username
	).sw_get_player_scores_complete
	print(username, ", ", endless_results)
	exists = not endless_results.scores.is_empty()
	
	return exists

func _on_confirm_pressed():
	if not all_good:
		confirm_butt.disabled = true
		confirm_butt.release_focus()
		await check_status(username_input.text.to_upper().strip_edges())
		
		if all_good:
			Global.online_prompted = true
			SaveHandler.save_key("online_prompted", Global.online_prompted)
			await get_tree().create_timer(2.0, false).timeout
			SceneSwitcher.switch_to("res://main_menu/main_menu.tscn")
		else:
			confirm_butt.disabled = false


func _on_username_text_changed(new_text: String) -> void:
	username_input.text = ""
	username_input.insert_text_at_caret(new_text.to_upper())
