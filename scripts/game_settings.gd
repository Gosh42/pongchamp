extends Popup

const SAVE_PATH = "res://save.cfg"
var config = ConfigFile.new()

func _on_play_button_pressed():
	_on_save_button_pressed()
	get_tree().change_scene("res://scenes/game.tscn")


func _on_save_button_pressed():
	
	config.set_value("game", "player1_playable", $CheckButton.pressed)
	config.set_value("game", "player2_playable", $CheckButton2.pressed)
	config.set_value("game", "required_score", $HSlider.value)
	
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
	
	$CheckButton.pressed = config.get_value("game", "player1_playable", true)
	$CheckButton2.pressed = config.get_value("game", "player2_playable", true)
	$HSlider.set_value(config.get_value("game", "required_score", 12))
	$Label.text = str(config.get_value("game", "required_score", 12))
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
	$Label.text = str(value)
