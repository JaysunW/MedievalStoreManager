extends Node2D

@export var build_service : Node2D

func Enter():
	pass

func Exit():
	build_service.child_exit()

func Process(_delta: float) -> void:
	if Input.is_action_pressed("right_mouse"):
		Exit()
		return
