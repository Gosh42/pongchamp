extends Control

onready var game_settings = $"/root/title screen/game settings/"

func _ready():
	if get_tree().current_scene.name == "title screen":
		$"VBoxContainer/play button".grab_focus()
	
func open_game_settings():
	game_settings.popup()
	game_settings._on_load_button_pressed()
	#get_tree().change_scene("res://scenes/game.tscn")
	
func information():
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


func language_swap():
	if "en" in TranslationServer.get_locale():
		TranslationServer.set_locale("ru")
	else:
		TranslationServer.set_locale("en")
	
	get_tree().reload_current_scene()
