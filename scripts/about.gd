extends Popup

onready var tab_container = $TabContainer
onready var anim = $menu_anim_player


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_close_button_down()
		
	if not visible:
		set_process(false)

func _on_close_button_down():
	anim.play("menu_disappear")


func change_tabs(next_tab):
	var x = tab_container.current_tab + next_tab
	
	if x < 0:
		tab_container.current_tab = tab_container.get_tab_count() - 1
	elif x > tab_container.get_tab_count() - 1:
		tab_container.current_tab = 0
	else:
		tab_container.current_tab = x
