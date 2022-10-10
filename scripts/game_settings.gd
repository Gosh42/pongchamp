extends Popup

const SAVE_PATH = "user://save.cfg"


onready var player1_check = $"/root/title screen/game settings/P1_toggle"
onready var player2_check = $"/root/title screen/game settings/P2_toggle"
onready var player1_colour_option = $"/root/title screen/game settings/P1_colour_option"
onready var player2_colour_option = $"/root/title screen/game settings/P2_colour_option"
onready var score_label = $"/root/title screen/game settings/score_label"
onready var score_slider = $"/root/title screen/game settings/score_slider"
onready var anim = $"/root/title screen/game settings/menu_anim_player"
onready var fullscreen_check = $"/root/title screen/game settings/fullscreen_toggle_button"



var config = ConfigFile.new()


func _process(_delta):
	if get_node("/root/title screen/game settings").visible:
		fullscreen_check.pressed = OS.window_fullscreen
	if Input.is_action_just_pressed("ui_cancel"):
		_on_close_button_pressed()
	
	if not visible:
		set_process(false)


func _on_play_button_pressed():
	var tween = get_parent().get_node("Tween")
	tween.interpolate_property(get_parent().get_node("CanvasLayer/fade_panel"),
		"modulate", Color(1,1,1,0), Color8(22, 0, 39, 255),
		0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	$Timer.start(0.5); yield($Timer, "timeout")
	
	_on_save_button_pressed()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/game.tscn")


func _on_save_button_pressed():
	
	config.set_value("game", "player1_playable", player1_check.pressed)
	config.set_value("game", "player2_playable", player2_check.pressed)
	config.set_value("game", "required_score", score_slider.value)
	config.set_value("game", "player1_colour", player1_colour_option.selected)
	config.set_value("game", "player2_colour", player2_colour_option.selected)
	
	config.save(SAVE_PATH)
	
	print("saved:")
	for i in config.get_sections():
		for j in config.get_section_keys(i):
			print(i, " ", j, " ", config.get_value(i, j))
	
	$load_button.disabled = false


func _on_load_button_pressed():
	
	var okay = config.load(SAVE_PATH)
	if okay != OK:
		print("game_settings.gd != OK")
		_on_save_button_pressed()
	
	player1_check.pressed = config.get_value("game", "player1_playable", true)
	player2_check.pressed = config.get_value("game", "player2_playable", true)
	
	player1_colour_option.selected = config.get_value("game", "player1_colour", 0)
	player2_colour_option.selected = config.get_value("game", "player2_colour", 1)
	
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

	_on_save_button_pressed()
	anim.play("menu_disappear")


func _on_HSlider_value_changed(value):
	score_label.text = str(value)


func _on_fullscreen_toggle_button_button_down():
	OS.window_fullscreen = !OS.window_fullscreen
	
