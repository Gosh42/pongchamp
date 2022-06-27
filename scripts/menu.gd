extends Control

var game_settings
var info_window
var tween

func _ready():
	if get_tree().current_scene.name == "title screen":
		tween = $Tween
		tween.interpolate_property($CanvasLayer/fade_panel, "modulate", 
			Color8(22, 0, 39, 255), Color(1,1,1,0), 
			1.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		
		if "en" in TranslationServer.get_locale():
			$"VBoxContainer/language button".icon = preload("res://gfx/flag_ru.png")
		else:
			$"VBoxContainer/language button".icon = preload("res://gfx/flag_en.png")
			
		$"VBoxContainer/play button".grab_focus()
		game_settings = $"game settings/"
		info_window = $"about"
	
func open_menu_window(menu_number):
	var menus = [game_settings, info_window]
	menus[menu_number].popup()
	menus[menu_number].get_node("AnimationPlayer").play("menu_appear")
	menus[menu_number].set_process(true)
	
	if menu_number == 0:
		game_settings._on_load_button_pressed()
	#get_tree().change_scene("res://scenes/game.tscn")


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
