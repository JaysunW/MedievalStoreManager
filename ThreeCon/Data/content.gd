extends Node2D

var goal_position = Vector2(-32,-32)
var content_data = null

func _process(delta):
	if goal_position != Vector2(-32,-32):
		var move_vec = goal_position - position
		position += move_vec.normalized() * delta * 400
		if move_vec.length() < 2:
			position = goal_position

func set_goal_position(pos):
	goal_position = pos

func set_content_data(_content):
	if _content:
		content_data = _content
		$Display.texture = content_data.get_texture()

func is_pressed(input):
	if input:
		$Display.scale = Vector2(1.2,1.2)
	else:
		$Display.scale = Vector2(0.9,0.9)

func get_content_data():
	return content_data
