extends Node

const CURRENT_GAME_VERSION: String = "1.0.0"

const SAVE_PATH: String = "user://save.cfg"
const USER_SECTION: String = "USER"

func check_compatibility(version: String) -> String:
	var upgraded_version: String = "1.0.0"
	
	match version:
		"NO SAVE":
			save_config()
			upgraded_version = CURRENT_GAME_VERSION
		CURRENT_GAME_VERSION:
			upgraded_version = CURRENT_GAME_VERSION
	
	return upgraded_version

func save_config() -> void:
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	
	config.set_value(USER_SECTION, "game_version", CURRENT_GAME_VERSION)
	
	config.set_value(USER_SECTION, "master_volume",
			AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Master")
	))
	config.set_value(USER_SECTION, "sound_volume",
			AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("sfx")
	))
	config.set_value(USER_SECTION, "music_volume",
			AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("music")
	))
	
	config.set_value(USER_SECTION, "latest_endless_score", Global.latest_endless_score)
	config.set_value(USER_SECTION, "endless_highscores", Global.endless_highscores)
	config.set_value(USER_SECTION, "username", Global.username)
	config.set_value(USER_SECTION, "online_prompted", Global.online_prompted)
	
	config.set_value(USER_SECTION, "move_left_keybinds", InputMap.action_get_events("move_left"))
	config.set_value(USER_SECTION, "move_up_keybinds", InputMap.action_get_events("move_up"))
	config.set_value(USER_SECTION, "move_right_keybinds", InputMap.action_get_events("move_right"))
	config.set_value(USER_SECTION, "move_down_keybinds", InputMap.action_get_events("move_down"))
	
	config.save(SAVE_PATH)

func save_key(key: String, value: Variant) -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		return
	
	config.set_value(USER_SECTION, key, value)
	
	config.save(SAVE_PATH)

func load_config() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	var save_version: String = "1.0.0"
	
	if error != OK:
		save_version = "NO SAVE"
	else:
		save_version = config.get_value(USER_SECTION, "game_version")
	
	while save_version != CURRENT_GAME_VERSION: 
		save_version = await check_compatibility(save_version)
	
	error = config.load(SAVE_PATH)
	if error != OK:
		return
	
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		config.get_value(USER_SECTION, "master_volume")
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("sfx"),
		config.get_value(USER_SECTION, "sound_volume")
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("music"),
		config.get_value(USER_SECTION, "music_volume")
	)
	
	Global.latest_endless_score = config.get_value(USER_SECTION, "latest_endless_score")
	Global.endless_highscores = config.get_value(USER_SECTION, "endless_highscores")
	Global.username = config.get_value(USER_SECTION, "username")
	Global.online_prompted = config.get_value(USER_SECTION, "online_prompted")
	
	var move_left_keybinds = config.get_value(USER_SECTION, "move_left_keybinds")
	var move_right_keybinds = config.get_value(USER_SECTION, "move_right_keybinds")
	
	InputMap.action_erase_events("move_left")
	for event: InputEvent in move_left_keybinds:
		InputMap.action_add_event("move_left", event)
	
	InputMap.action_erase_events("move_right")
	for event: InputEvent in move_right_keybinds:
		InputMap.action_add_event("move_right", event)
