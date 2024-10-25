extends Node

@export var is_ui_open = true
@export var blocking_script : Node

func is_ui_free():
	return is_ui_open

func is_free(input):
	is_ui_open = input
