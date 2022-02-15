extends Node

const SAVE_PATH = "res://save.cfg"
onready var config = ConfigFile.new()

func save_file():
	config.set_value("game", "player1_playable", true)
	config.set_value("game", "player1_playable", false)
	config.set_value("game", "required_score", 4)
	
	config.save(SAVE_PATH)

func load_file(section, key):
	config.get_value(section, key, null)
