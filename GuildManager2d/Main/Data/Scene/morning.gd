extends State

@export var time_service: Node2D 

func Enter():
	time_service.change_time(0)
