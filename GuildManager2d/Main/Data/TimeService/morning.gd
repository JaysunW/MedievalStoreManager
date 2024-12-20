extends State

@export var time_service: Node2D 

func Enter():
	time_service.show_time_mode("Morning")
	time_service.show_time()
