extends Node2D

var grid_position = Vector2.ZERO

var content = null
var fill_direction = Vector2.UP
var mouse_position = Vector2.ZERO
var pressed = false
var contaminated = false
var contamination_level = 0
var content_obstructed = false
var content_moveable = true

signal special_destroyed(pos, type)

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
			content_moved.emit(grid_position, move_dir)

func set_contamination(count):
	contaminated = true
	contamination_level = count
	$Contamination.visible = true
	$Contamination/Label.text = str(contamination_level)

func set_content(_content):
	content = _content
	if content:
		content.is_pressed(false)

func set_fill_direction(direction):
	fill_direction = direction
	
func delete_content():
	if contaminated:
		contamination_level -= 1
		$Contamination/Label.text = str(contamination_level)
		if contamination_level == 0:
			contaminated = false
			$Contamination.visible = false
	var temporary_content = content
	content.queue_free()
	content = null
	if temporary_content.get_content_data().is_special():
		special_destroyed.emit(grid_position, temporary_content.get_content_data().get_type())

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

func get_special_destroyed_signal():
	return special_destroyed
	
func has_content():
	return content != null

func is_special():
	return content.get_content_data().is_special()
	
func get_content():
	return content

func get_content_type():
	return content.get_content_data().get_type()

func get_grid_position():
	return grid_position

func _on_button_button_down():
	button_pressed(true)

func _on_button_button_up():
	button_pressed(false)
