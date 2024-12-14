extends CanvasLayer

@export var time_mode_label: Label 
@export var time_label: Label

func set_time(current_time):
	var minutes = current_time % 60
	var hours = int((current_time - minutes) / 60) + 8
	minutes = str(minutes) if minutes > 9 else "0" + str(minutes)
	time_label.text = str(hours , ":") + minutes

func set_time_mode(mode):
	time_mode_label.text = str(mode)
