extends KinematicBody2D

onready var screenSize = ProjectSettings.get_setting\
							("display/window/size/width")
onready var sprites = [preload("res://gfx/pongman2_ball.png"), \
						preload("res://gfx/pongman2_ball2.png")]

var defaultSpeed = 400
var startpos
var speed = 400
var movement = Vector2.ZERO #speed + direction or something like that

var rng = RandomNumberGenerator.new()
signal addScore(side)

func _physics_process(delta):
	var collision = move_and_collide(speed * movement * delta)
	
	if collision:
		print(collision.collider.name)
		movement = movement.bounce(collision.normal)
		print(movement)
		
		if collision.collider.name.left(6) == "death":
			if global_position.x < screenSize / 2:
				emit_signal("addScore", 1)
			else: emit_signal("addScore", 0)
			spawn()
			
		#elif speed < defaultSpeed * 2.5 and not collision.collider.name.left(6) == "walls":
		#	speed += 50
		#	print(speed)
		elif not collision.collider.name == "walls":
			speed += round(collision.collider.movement.y / 5.5 * sign(movement.y))
			speed = clamp(speed, defaultSpeed, speed * 3)
			print(speed)
			
		if abs(movement.y) > sin(PI/3):
			movement = Vector2(movement.x / abs(movement.x) * cos(PI/3), movement.y / abs(movement.y) * sin(PI/3))
	
	$Sprite.rotate(movement.y / 5)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
# warning-ignore:return_value_discarded
	connect("addScore", get_tree().get_root().get_node("Node"), "_add_score")


func spawn():
	#Берёт спрайт из массива. Индекс - случайный от 0 до 3, но лимитируется
	#до от 0 до 1, чтобы с шансом 25% взять 1-й спрайт, а с 75%-м - второй
	$Sprite.texture = sprites[clamp(rng.randi_range(0, 3), 0, 1)]
	
	global_position = startpos
	speed = defaultSpeed
	movement = Vector2.ZERO
	var angle = 0
	while (angle % 90 == 0):
		angle = 30 * rng.randi_range(1, 11)
	angle = deg2rad(angle)
	yield(get_tree().create_timer(1.0), "timeout")
	movement = Vector2(cos(angle), -sin(angle)).normalized()
