extends Camera2D

var shake_amount
var default_offset = offset
onready var timer = $"camera timer"

func _ready():
	set_process(false)
	randomize()

func _process(_delta):
	offset.x = rand_range(-1, 1) * shake_amount
	offset.y = rand_range(-1, 1) * shake_amount

func start_shaking(s_amount, shake_duration):
	shake_amount = s_amount
	
	set_process(true)
	timer.start(shake_duration)

func _on_camera_timer_timeout():
	set_process(false)
	offset = default_offset
