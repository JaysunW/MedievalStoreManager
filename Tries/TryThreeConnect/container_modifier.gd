extends Node2D

var current_count = 0 

func set_count(input):
	current_count = input
	update_count()

func decrease_count():
	current_count -= 1
	update_count()

func update_count():
	$Sprite/Label.text = str(current_count)

func set_sprite(input):
	$Sprite.texture = input
