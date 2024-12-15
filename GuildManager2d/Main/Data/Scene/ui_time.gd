extends CanvasLayer

@export var time_mode_label: Label 
@export var time_label: Label

func set_time(minute, hour):
	minute = str(minute) if minute > 9 else "0" + str(minute)
	time_label.text = str(hour , ":") + minute

func set_time_mode(mode):
	time_mode_label.text = str(mode)
