extends Control

func _ready():
	if get_tree().current_scene.name == "title screen":
		$"VBoxContainer/play button".grab_focus()
	
func play():
	$"game settings".popup()
	$"game settings"._on_load_button_pressed()
	#get_tree().change_scene("res://scenes/game.tscn")
	
func settings():
	print("открылись бы настройки\nно я их ещё не запрограммировал")
	
func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func quit():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/title_screen.tscn")

func resume():
	get_tree().paused = false
	hide()
