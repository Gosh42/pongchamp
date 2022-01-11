extends KinematicBody2D

var maxSpeed = 450
var acceleration = 7500
var movement = Vector2.ZERO
var startpos
var ball

var inputDown = "ui_down"
var inputUp = "ui_up"

var axis = Vector2.ZERO
onready var anim = $AnimationPlayer

var playable
var aiSide

func _physics_process(delta):
	#getting the input axis: if playable, get it from controls. else, let the ai do it
	if playable:
		axis = Vector2(0, int(Input.is_action_pressed(inputDown)) -
		int(Input.is_action_pressed(inputUp)))
	else: #artificial intelligence í ½í¸³í ½í¸³í ½í¸³í ½í¸³í ½í¸³í ½í¸³í ½í¸³:flushed:
		if(ball.movement.x * (-aiSide) < 0):
			if (global_position.y > ball.global_position.y):
				axis = Vector2(0, -1)
			else:
				axis = Vector2(0, 1) 
		else:
			axis = Vector2(0, 0)
	
	#if not going to move, start slowing down. else move
	if axis == Vector2.ZERO:
		applyFriction(acceleration * delta)
		anim.play("idle")
	else:
		applyMovement(acceleration * delta * axis)
		anim.play("Walk_down") if axis.y > 0 else anim.play("Walk_up")
		
	movement = move_and_slide(movement)
	global_position.x = startpos

func applyFriction(amount):
	if movement.length() > amount:
		movement -= movement.normalized() * amount
	else:
		movement = Vector2.ZERO

func applyMovement(amount):
	movement += amount
	movement = movement.clamped(maxSpeed)

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
