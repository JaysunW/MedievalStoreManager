extends Control

@onready var counter_label = $TextureRect/Label

func update(value):
	counter_label.text = str(value)
