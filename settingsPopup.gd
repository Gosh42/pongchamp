extends Popup

var save_path = "res://save.cfg"
var config = ConfigFile.new()
var settings = {
	"base_settings": {
		
	}
}

func _ready():
	get_parent().get_parent()
#	_on_maxScore_value_changed(4)
	
#func _on_maxScore_value_changed(value):
	#$TabContainer/VBoxContainer/maxScoreText.text = tr("SCORE_TO_WIN") \
	#+ "\n\n" + str(value)
