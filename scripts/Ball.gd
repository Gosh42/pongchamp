extends KinematicBody2D

var rng = RandomNumberGenerator.new()
signal add_score

onready var sprite = $Sprite
onready var timer = $Timer
onready var tween = $Tween
onready var sndplr_hit = $sound_player_hit
onready var sndplr_appear = $sound_player_appear
onready var sndplr_explode = $sound_player_explode
onready var camera = $"%Camera2D"
onready var appear_particle = $"%ball_materialise"
onready var perish_particle = $"%ball_explode"

#onready var hit_sound = preload("res://audio/hit.wav")
onready var appear_sounds = [
#	preload("res://audio/appear_01.wav"),
#	preload("res://audio/appear_07.wav"),
#	preload("res://audio/appear_09.wav"),
	preload("res://audio/appear5.wav"),
	preload("res://audio/appear4.wav"),
	preload("res://audio/appear6.wav")
]
onready var explosion_sounds = [
	preload("res://audio/explosion.wav"),
	preload("res://audio/explosion2.wav"),
	preload("res://audio/explosion3.wav")
]
onready var sprite_images = [
	preload("res://gfx/ball_normal.png"),
	preload("res://gfx/ball_coconut.png")
]

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
		if speed > 350:
			camera.start_shaking(speed / 300, 0.05) 
		
		if collision.collider.name == "death":
			play_important_sound(sndplr_explode, explosion_sounds)
			
			camera.start_shaking(10, 0.25)
			perish_particle.global_position = global_position
			perish_particle.emitting = true
			
			if global_position.x < startpos.x:
				emit_signal("add_score", 1)
				perish_particle.direction.x = 1
			else:
				emit_signal("add_score", 0)
				perish_particle.direction.x = -1
			spawn()
				
		elif not collision.collider.name == "walls":
			speed += round(collision.collider.velocity.y /5.5* sign(velocity.y))
			speed = clamp(speed, default_speed, default_speed * 3)
			print(speed)
			collision.collider.anim_shield.play("shield_knockback")
		
		sndplr_hit.pitch_scale = 1 + speed / 2000
		sndplr_hit.volume_db + speed / 200
		sndplr_hit.play()
		
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
	
	sprite.modulate = Color(1, 1, 1, 0)
	
	timer.start(0.2)
	yield(timer, "timeout")
	
	appear_particle.emitting = true
	play_important_sound(sndplr_appear, appear_sounds)
	
	timer.start(appear_particle.lifetime / appear_particle.speed_scale / 0.9)
	yield(timer, "timeout")
	
	tween.interpolate_property(sprite, "modulate", 
		Color8(22, 0, 39, 0), Color(1, 1, 1, 1), 
		0.50, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	
	timer.start(0.3)
	yield(timer, "timeout")
	
	velocity = Vector2(cos(angle), -sin(angle)).normalized()

func play_important_sound(sound_player, sound_list):
	sound_player.stream = sound_list[randi() % sound_list.size()]
	sound_player.pitch_scale = 1 + rand_range(-0.2, 0.2)
	
	sound_player.play()
