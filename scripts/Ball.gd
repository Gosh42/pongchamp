extends KinematicBody2D

var rng = RandomNumberGenerator.new()
signal add_score

onready var sprite = $Sprite
onready var sprite_images = [preload("res://gfx/ball_normal.png"), \
	preload("res://gfx/ball_coconut.png")]
onready var startpos = global_position

var default_speed = 250
var speed = default_speed

var velocity = Vector2.ZERO


func _ready():
# warning-ignore:return_value_discarded
	connect("add_score", get_owner(), "add_score")
	rng.randomize()
	spawn()

func _physics_process(delta):
	var collision = move_and_collide(speed * velocity * delta)
	
	if collision:
		if collision.collider.name == "death":
			if global_position.x < startpos.x:
				emit_signal("add_score", 1)
				print("goal_left")
			else:
				emit_signal("add_score", 0)
				print("goal_right")
			spawn()
				
		elif not collision.collider.name == "walls":
			speed += round(collision.collider.velocity.y /5.5* sign(velocity.y))
			speed = clamp(speed, default_speed, default_speed * 3)
			print(speed)
		
		velocity = velocity.bounce(collision.normal)
		
		if abs(velocity.y) > sin(PI/3):
			velocity = Vector2(sign(velocity.x) * cos(PI/3), \
				sign(velocity.y) * sin(PI/3))
				
	sprite.rotate(velocity.y / 5)

func spawn():
	
	global_position = startpos
	sprite.texture = sprite_images[clamp(rng.randi_range(-2, 1), 0, 1)]
	
	speed = default_speed
	velocity = Vector2.ZERO
	
	var angle = 0
	while (angle % 90 == 0):
		angle = 30 * rng.randi_range(1, 11)
	angle = deg2rad(angle)
	
	var tween = $"Tween"
	tween.interpolate_property($"Sprite", "modulate", 
		Color8(22, 0, 39, 0), Color(1, 1, 1, 1), 
		0.50, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	
	$Timer.start(1.0); yield($Timer, "timeout")
	#yield(get_tree().create_timer(1.0), "timeout")
	velocity = Vector2(cos(angle), -sin(angle)).normalized()
