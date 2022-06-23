extends Popup

const SAVE_PATH = "user://save.cfg"

onready var player1_check = $"/root/title screen/game settings/CheckButton"
onready var player2_check = $"/root/title screen/game settings/CheckButton2"
onready var score_label = $"/root/title screen/game settings/score_label"
onready var score_slider = $"/root/title screen/game settings/score_slider"


var config = ConfigFile.new()


func _on_play_button_pressed():
	_on_save_button_pressed()
	get_tree().change_scene("res://scenes/game.tscn")


func _on_save_button_pressed():
	
	config.set_value("game", "player1_playable", player1_check.pressed)
	config.set_value("game", "player2_playable", player2_check.pressed)
	config.set_value("game", "required_score", score_slider.value)

	config.save(SAVE_PATH)
	
	print("saved:")
	for i in config.get_sections():
		for j in config.get_section_keys(i):
			print(i, " ", j, " ", config.get_value(i, j))
	
	$load_button.disabled = false


func _on_load_button_pressed():
	
	var okay = config.load(SAVE_PATH)
	if okay != OK:
		print("among us")
		_on_save_button_pressed()
	
	player1_check.pressed = config.get_value("game", "player1_playable", true)
	player2_check.pressed = config.get_value("game", "player2_playable", true)
	
	score_slider.set_value(config.get_value("game", "required_score", 12))
	score_label.text = str(config.get_value("game", "required_score", 12))
	
	print("loaded:")
	for i in config.get_sections():
		for j in config.get_section_keys(i):
			print(i, " ", j, " ", config.get_value(i, j))

func load_value(section, key):
	config.load(SAVE_PATH)
	return config.get_value(section, key)

func _on_close_button_pressed():
	hide()


func _on_HSlider_value_changed(value):
	score_label.text = str(value)
