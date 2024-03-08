extends Control

@onready var bar = $Control/Progress

func update(percentage):
	bar.value = percentage
	
func set_front_sprite(input):
	$Control/Front.texture = input

func set_back_sprite(input):
	$Control/Back.texture = input
