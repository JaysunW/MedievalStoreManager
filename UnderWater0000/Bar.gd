extends Control

@onready var bar = $Progress

func update(percentage):
	bar.value = percentage
