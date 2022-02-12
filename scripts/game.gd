extends Node2D

onready var scoreboard = [$"UI/GUI/score left", $"UI/GUI/score right"]
onready var pause = $UI/GUI/pause
var score = [0, 0]
var finish_score = 4

func _ready():
	pause.hide()

func add_score(side):
	score[side] += 1
	scoreboard[side].text = str(score[side])
	
	if score[side] == finish_score:
		yield(get_tree().create_timer(0.5), "timeout")
		game_over(side)

func game_over(side):
	$UI/GUI.hide()
	print("player %s win" % side)


func pause_button_pressed():
	get_tree().paused = !get_tree().paused
	$UI/GUI/pause.visible = !$UI/GUI/pause.visible
