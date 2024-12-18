extends Node2D

@export var time_service : Node2D

func interact():
	time_service.start_work_day()
