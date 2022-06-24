extends Popup

onready var tab_container = $TabContainer

func _on_close_button_button_down():
	hide()


func change_tabs(next_tab):
	var x = tab_container.current_tab + next_tab
	
	if x < 0:
		tab_container.current_tab = tab_container.get_tab_count() - 1
	elif x > tab_container.get_tab_count() - 1:
		tab_container.current_tab = 0
	else:
		tab_container.current_tab = x
