extends Control

func resume():
	get_tree().paused = false
	hide()
	
func quit():
	print("ну типо вышел в меню\nя его не запрограммировал ещё прост")
	resume()
