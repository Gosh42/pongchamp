extends KinematicBody2D

var rng = RandomNumberGenerator.new()
signal add_score

onready var sprites = [preload("res://gfx/ball_normal.png"), \
	preload("res://gfx/ball_coconut.png")]
onready var screen_middle = global_position.x

var default_speed = 250
var speed = default_speed

var velocity = Vector2.ZERO


func _ready():
	connect("add_score", get_owner(), "add_score")
	rng.randomize()
	spawn()

func _physics_process(delta):
	var collision = move_and_collide(speed * velocity * delta)
	
	if collision:
		if collision.collider.name == "death":
			if global_position.x < screen_middle:
				emit_signal("add_score", 1)
				print("goal_left")
			else:
				emit_signal("add_score", 0)
				print("goal_right")
				
		elif not collision.collider.name == "walls":
			speed += round(collision.collider.velocity.y /5.5* sign(velocity.y))
			speed = clamp(speed, default_speed, default_speed * 3)
			print(speed)
		
		velocity = velocity.bounce(collision.normal)
		
		if abs(velocity.y) > sin(PI/3):
			velocity = Vector2(sign(velocity.x) * cos(PI/3), \
				sign(velocity.y) * sin(PI/3))
				
	$Sprite.rotate(velocity.y / 5)

func spawn():
	$Sprite.texture = sprites[clamp(rng.randi_range(0, 3), 0, 1)]
	
	speed = default_speed
	velocity = Vector2.ZERO
	
	var angle = 0
	while (angle % 90 == 0):
		angle = 30 * rng.randi_range(1, 11)
	angle = deg2rad(angle)
	
	yield(get_tree().create_timer(1.0), "timeout")
	velocity = Vector2(cos(angle), -sin(angle)).normalized()
