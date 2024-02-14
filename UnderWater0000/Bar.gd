extends Control

@onready var bar = $Control/Progress

func update(percentage):
	bar.value = percentage
