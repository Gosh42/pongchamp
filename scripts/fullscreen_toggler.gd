extends Node

#onready var game_settings = get_node("/root/SaveConfig")

func _input(ev):
	if ev.is_action_pressed("toggle_fullscreen"):
		GameSettings._on_fullscreen_toggle_button_button_down()
