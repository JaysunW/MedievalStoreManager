extends Node2D

@onready var sprite = $Display
var pos = Vector2.ZERO
var type = ""
var mouse_position = Vector2.ZERO
var pressed = false

signal gem_moved(pos, move_dir)

func _process(_delta):
	if pressed:
		var distance_vec = get_viewport().get_mouse_position() - mouse_position
		if distance_vec.length() > 16:
			pressed = false
			print(distance_vec)
			if abs(distance_vec.x) > abs(distance_vec.y):
				print(Vector2(distance_vec.x, 0).normalized())
			else:
				print(Vector2(0, distance_vec.y).normalized())
				
func setup_display(input):
	sprite.texture = input

func set_type(input):
	type = input

func _on_button_button_down():
	mouse_position = get_viewport().get_mouse_position()
	pressed = true
	sprite.scale = Vector2(1.2,1.2)

func _on_button_button_up():
	pressed = false
	sprite.scale = Vector2(1,1)

func get_type():
	return type
	
func get_sprite():
	return sprite.texture
