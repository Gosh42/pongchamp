extends Node2D

onready var scoreboard = [$"UI/GUI/score left", $"UI/GUI/score right"]
onready var pause = $UI/pause
onready var pause_anim = pause.get_node("AnimationPlayer")
#onready var gameover_screen = $UI/gameover
onready var paddle_left = $"objects/left paddle"
onready var paddle_right = $"objects/right paddle"
onready var ball = $objects/ball 
onready var tween = $Tween
var score = [0, 0]
var finish_score = 1

func _ready():
	pause.hide()
#	gameover_screen.hide()
	
	paddle_left.playable = SaveConfig.load_value("game", "player1_playable")
	$UI/GUI/touch_ctrl_left.visible = paddle_left.playable
	paddle_right.playable = SaveConfig.load_value("game", "player2_playable")
	$UI/GUI/touch_ctrl_right.visible = paddle_right.playable
	
	finish_score = SaveConfig.load_value("game", "required_score")
	
	tween.interpolate_property($fade_in/fade_panel, "modulate", 
		Color8(22, 0, 39, 255), Color(1,1,1,0), 
		0.75, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_button_pressed()

func add_score(side):
	score[side] += 1
	scoreboard[side].text = str(score[side])
	
	if score[side] == finish_score:
		game_over(side)

func game_over(side):
	get_tree().paused = true
	ball.hide()
	yield(get_tree().create_timer(0.5), "timeout")
	
	$UI/GUI.hide()
	pause.get_node("VBoxContainer/resume button").queue_free()
	pause.get_node("text").text = tr("END_CONGRATS").format({n=side+1})
	pause.show()
	pause_anim.play("menu_appear")
	pause.get_node("VBoxContainer/restart button").grab_focus()
#	gameover_screen.show()
#	$"UI/gameover/VBoxContainer/restart button".grab_focus()
#	$"UI/gameover/winner text".text = tr("END_CONGRATS").format({n=side+1})
	print("player %s win" % (side+1))


func pause_button_pressed():
	get_tree().paused = not get_tree().paused
	
	if get_tree().paused:
		pause.visible = true
		pause_anim.play("menu_appear")
		pause.get_node("VBoxContainer/resume button").grab_focus()
	else:
		pause_anim.play("menu_disappear")
