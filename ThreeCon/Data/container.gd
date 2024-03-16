extends Node2D

var grid_position = Vector2.ZERO

var content = null
var fill_direction = Vector2.UP
var mouse_position = Vector2.ZERO
var pressed = false

signal content_moved(grid_position, move_dir)
	
func _process(_delta):
	if pressed:
		var distance_vec = get_viewport().get_mouse_position() - mouse_position
		if distance_vec.length() > 16:
			var move_dir = Vector2.ZERO
			if abs(distance_vec.x) > abs(distance_vec.y):
				move_dir = Vector2(distance_vec.x, 0).normalized()
			else:
				move_dir = Vector2(0, distance_vec.y).normalized()
			$Back/Button.button_pressed = false
			button_pressed(false)
			content_moved.emit(grid_position, move_dir)
			
func set_content(_content):
	content = _content
	
func delete_content():
	content.queue_free()
	content = null

func set_grid_position(_grid_position):
	grid_position = _grid_position

func highlight(r, g, b):
	$Back.self_modulate = Color(r, g, b)
	
func button_pressed(input):
	if content:
		pressed = input
		mouse_position = get_viewport().get_mouse_position()
		content.is_pressed(input)

func get_fill_direction():
	return fill_direction

func get_content_moved_signal():
	return content_moved

func has_content():
	return content != null

func get_content():
	return content

func get_grid_position():
	return grid_position

func _on_button_button_down():
	button_pressed(true)

func _on_button_button_up():
	button_pressed(false)
