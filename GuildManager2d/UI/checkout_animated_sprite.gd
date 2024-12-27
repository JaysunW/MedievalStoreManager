extends AnimatedSprite2D

var target_position = null
var start_position = null
var target_scale = null
var start_scale = null
var start_color = null
var target_color = null

var is_last_position = false

var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_target_scale(input : Vector2):
	start_scale = scale
	target_scale = input
	
func set_target_color(input : Color):
	start_color = modulate
	target_color = input

func set_target_position(input : Vector2):
	start_position = position
	target_position = input

func last_position():
	is_last_position = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not target_position:
		return
		
	if position.distance_to(target_position) < 16:
		target_position = null
		target_scale = null
		target_color = null
		if is_last_position:
			queue_free()
		return
	
	var dir = position.direction_to(target_position)
	var added_speed = 0
	if is_last_position:
		added_speed = 100
	position += delta * (speed + added_speed)  * dir 
	var start_distance = position.distance_to(start_position)
	var complete_distance = start_position.distance_to(target_position)
	if target_color:
		var color_value = remap(start_distance, 0, complete_distance, start_color.r, target_color.r)
		modulate = Color(color_value, color_value, color_value)
	if target_scale:
		var scale_value = remap(start_distance, 0, complete_distance, start_scale.x, target_scale.x)
		scale = Vector2.ONE * scale_value
		
