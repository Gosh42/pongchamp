extends KinematicBody2D

onready var start_pos = global_position.x
onready var anim = $AnimationPlayer
onready var anim_shield = $AnimationPlayerShield
onready var ball = get_parent().get_node("ball")
onready var ai_side = 1 if name.begins_with('l') else -1
export var playable = true

var max_speed = 275
var acceleration = 3000
var velocity = Vector2.ZERO

var axis = Vector2.ZERO
export var input_down = "plr1_down"
export var input_up = "plr1_up"


func _ready():
	var chosen_colour = GameSettings.load_value("game", "player1_colour" if name.begins_with('l') else "player2_colour")
	match chosen_colour:
		0: # red
			material.set_shader_param("new_bright", Color("#b4202a"))
			material.set_shader_param("new_normal", Color("#730b25"))
			material.set_shader_param("new_dark", Color("#450814"))
		1: # green
			material.set_shader_param("new_bright", Color("#549e2f"))
			material.set_shader_param("new_normal", Color("#156b35"))
			material.set_shader_param("new_dark", Color("#0b4732"))
		2: # blue
			material.set_shader_param("new_bright", Color("#226287"))
			material.set_shader_param("new_normal", Color("#0d2773"))
			material.set_shader_param("new_dark", Color("#101236"))

func _physics_process(delta):
	# Determines where to move either from player controls
	# or the position of the ball, if AI-controlled
	if playable:
		axis = Vector2(0, int(Input.is_action_pressed(input_down)) -
		int(Input.is_action_pressed(input_up)))
	else:
		if(ball.velocity.x * ai_side < 0):
			if (global_position.y > ball.global_position.y):
				axis = Vector2(0, -1)
			else:
				axis = Vector2(0, 1) 
		else:
			axis = Vector2(0, 0)
	
	# Start slowing down if not going to move, otherwise move
	if axis == Vector2.ZERO:
		decelerate(acceleration * delta)
		anim.play("idle")
	else:
		accelerate(acceleration * delta * axis)
		if axis.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")
	
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	global_position.x = start_pos
	
func accelerate(amount):
	velocity = (velocity + amount).limit_length(max_speed)

func decelerate(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount	
	else:
		velocity = Vector2.ZERO
