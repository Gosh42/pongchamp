extends Control

var game_settings
var info_window
var tween

func _ready():
	if get_tree().current_scene.name == "title screen":
		$CanvasLayer/fade_panel.show()
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
	menus[menu_number].get_node("menu_anim_player").play("menu_appear")
	menus[menu_number].set_process(true)
	
	if menu_number == 0:
		game_settings._on_load_button_pressed()
		game_settings.fullscreen_check.pressed = OS.window_fullscreen
	#get_tree().change_scene("res://scenes/game.tscn")


func restart():
	fade_out_in_game()
	$Timer.start(0.75); yield($Timer, "timeout")
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	
func quit():
	fade_out_in_game()
	$Timer.start(0.75); yield($Timer, "timeout")
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/title_screen.tscn")

func resume():
	get_parent().get_parent().pause_button_pressed()
#	get_tree().paused = false
#	hide()

func fade_out_in_game():
	tween = get_parent().get_parent().get_node("Tween")
	tween.interpolate_property(get_parent().get_parent().get_node("fade_in/fade_panel"), "modulate", 
		Color(1,1,1,0), Color8(22, 0, 39, 255), 
		0.70, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

	if get_node_or_null("VBoxContainer/resume button") != null:
		$"VBoxContainer/resume button".disabled = true
	$"VBoxContainer/restart button".disabled = true
	$"VBoxContainer/quit button".disabled = true

func language_swap():
	if "en" in TranslationServer.get_locale():
		TranslationServer.set_locale("ru")
	else:
		TranslationServer.set_locale("en")
	
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
