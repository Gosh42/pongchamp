extends Node2D

onready var scoreboard = [$"UI/GUI/score left", $"UI/GUI/score right"]
onready var pause = $UI/pause
onready var gameover_screen = $UI/gameover
onready var paddle_left = $"objects/left paddle"
onready var paddle_right = $"objects/right paddle"
onready var ball = $objects/ball 
var score = [0, 0]
var finish_score = 1

func _ready():
	pause.hide()
	gameover_screen.hide()
	paddle_left.playable = SaveConfig.load_value("game", "player1_playable")
	paddle_right.playable = SaveConfig.load_value("game", "player2_playable")
	finish_score = SaveConfig.load_value("game", "required_score")

func _process(delta):
	if not get_tree().paused and Input.is_action_just_pressed("ui_cancel"):
		pause_button_pressed()

func add_score(side):
	score[side] += 1
	scoreboard[side].text = str(score[side])
	
	if score[side] == finish_score:
		game_over(side)

func game_over(side):
	get_tree().paused = true
	$"UI/gameover/VBoxContainer/restart button".grab_focus()
	ball.hide()
	yield(get_tree().create_timer(0.5), "timeout")
	
	$UI/GUI.hide()
	gameover_screen.show()
	$"UI/gameover/winner text".text = "Player %s wins!" % (side + 1)
	print("player %s win" % side)


func pause_button_pressed():
	get_tree().paused = not get_tree().paused
	pause.visible = not pause.visible
	if get_tree().paused:
		pause.get_node("VBoxContainer/resume button").grab_focus()
