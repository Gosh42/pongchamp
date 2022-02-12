extends Node
#загрузка объектов и размера поля
var paddleLoad = preload("res://paddle.tscn")
var ballLoad = preload("res://Ball.tscn")
var screenSize=Vector2(ProjectSettings.get_setting("display/window/size/width"), \
	ProjectSettings.get_setting("display/window/size/height"))

onready var titleScreen = $menu/settings
onready var pauseScreen = $menu/pause
onready var gameover = $menu/afterlife
onready var obj = $gameObjects
#onready var bg = $gameObjects/bg
onready var scoreboard = [$"UI/GUI/score left", $"UI/GUI/score right"]
var score = [0,0]
#стандартные настройки
const MAX_SPEED = 275
const ACCELERATION = 3000 #3750
const AI_SPEED_MOD = 0.8
const AI_ACCEL_MOD = 0.66
const DEFAULT_X = 8 #left paddle pos = screen/X, right = screen - screen/X
const BALL_SPEED = 250
const DEFAULT_SCORE = 5

var maxSpeed
var acceleration
var aiSpeed
var aiAccel
var xOffset
var ballSpeed
var finishScore
#управление игроков
var inputDown = ["plr_left_down", "plr_right_down"]
var inputUp = ["plr_left_up", "plr_right_up"]
var playable = [true, true]
var aiSide = [-1, 1]

var ball

func _ready():
	resetToDefault()
	$bg.hide()
	set_process(false)
	$menu/settings/HBoxContainer/start_button.grab_focus()
	#$menu/settingsPopup.popup()

# warning-ignore:unused_argument
func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		print("павуза")
		pauseToggle()
	

func startGame():
	get_tree().paused = false
	finishScore = 4 #$menu/settings/maxScore.value
	removeObjects()
	#yield(get_tree().create_timer(0.5), "timeout")
	#скрытие паузы
	titleScreen.hide()
	gameover.hide()
	$bg.show()
	$UI/GUI.show()
	#сброс очков
	score = [0, 0]
	scoreboard[0].text = "0"
	scoreboard[1].text = "0"
	#спавн объектов
	ball = createBall()
	var _leftPaddle = createPaddleAt(screenSize.x / xOffset, 0)
	var rightPaddle = createPaddleAt(screenSize.x - screenSize.x / xOffset, 1)
	rightPaddle.scale.x = -1
	$UI/GUI/pauseButton.grab_focus()
	set_process(true)

func createPaddleAt(pos, input):
	var paddle = paddleLoad.instance()
	obj.add_child(paddle)
	paddle.global_position.x = pos
	paddle.global_position.y = screenSize.y / 2
	
	paddle.maxSpeed = maxSpeed if (playable[input]) else maxSpeed * aiSpeed
	paddle.acceleration = acceleration if (playable[input]) else acceleration * aiAccel
	paddle.inputDown = inputDown[input]
	paddle.inputUp = inputUp[input]
	paddle.startpos = pos
	paddle.playable = playable[input]
	paddle.aiSide = aiSide[input]
	paddle.ball = ball
	print (paddle.maxSpeed)
	return paddle

func createBall():
	var balls = ballLoad.instance()
	obj.add_child(balls)
	
	balls.startpos = Vector2(screenSize.x / 2, screenSize.y / 2)
	balls.defaultSpeed = ballSpeed
	balls.speed = ballSpeed
	balls.spawn()
	
	return balls

#установка настроек по умолчанию
func resetToDefault():
	maxSpeed = MAX_SPEED
	acceleration = ACCELERATION
	aiSpeed = AI_SPEED_MOD
	aiAccel = AI_ACCEL_MOD
	xOffset = DEFAULT_X
	ballSpeed = BALL_SPEED
	finishScore = DEFAULT_SCORE

func _add_score(side):
	score[side] += 1
	scoreboard[side].text = str(score[side])
	print("удар справа" if side == 0 else "удар слева")
	
	if score[side] == finishScore:
		yield(get_tree().create_timer(0.5), "timeout")
		death(side)

func death(side):
	set_process(false)
	$menu/afterlife/VBoxContainer/restart.grab_focus()
	print("yooo player %d won lets gooo" % (side + 1))
	
	get_tree().paused = true
	pauseScreen.hide()
	gameover.show()
	$UI/GUI.hide()
	ball.hide()
	
	var wintext = tr("END_CONGRATS")
	$menu/afterlife/congrats.text = wintext.format({n=side+1})
func removeObjects():
	#удаление объектов, если они есть
	if obj.get_child_count() > 0:
		for n in obj.get_children():
			n.queue_free()

func stopEverything():
	print("Kris Get The Banana")
	yield(get_tree().create_timer(0.5), "timeout")
	
	get_tree().paused = false
	
	gameover.hide()
	$bg.hide()
	$UI/GUI.hide()
	pauseScreen.hide()
	removeObjects()
	
	titleScreen.show()
	
	score = [0, 0]
	scoreboard[0].text = ""
	scoreboard[1].text = ""
	
	$menu/settings/HBoxContainer/start_button.grab_focus()
	set_process(false)

func pauseToggle():
	pauseScreen.set_visible(!pauseScreen.visible)
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		$menu/pause/VBoxContainer/continue.grab_focus()
	else:
		#yield(get_tree().create_timer(0.05), "timeout")
		$UI/GUI/pauseButton.grab_focus()


# warning-ignore:unused_argument
func _on_Playable_toggled(button_pressed, extra_arg_0):
	playable[extra_arg_0] = !playable[extra_arg_0]
	if (extra_arg_0 == 0):
		$UI/GUI/ctrl_player_1.visible = !$UI/GUI/ctrl_player_1.visible
	else:
		$UI/GUI/ctrl_player_2.visible = !$UI/GUI/ctrl_player_2.visible
	print(extra_arg_0)




func langSwap():
	if TranslationServer.get_locale() == "en":
		TranslationServer.set_locale("ru")
	else:
		TranslationServer.set_locale("en")
	get_tree().reload_current_scene()
#func hideMenus():
#	pauseScreen.hide()
#	gameover.hide()
#	$UI/GUI.hide()
