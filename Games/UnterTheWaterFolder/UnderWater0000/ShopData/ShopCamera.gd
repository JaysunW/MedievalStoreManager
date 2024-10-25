extends Camera2D

var start_pos = position
var highest_offset = 40
var follow_point = position
var speed = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vec_to_mouse = get_global_mouse_position() - position
	position += vec_to_mouse * speed * delta
	position.x =clamp(start_pos.x + position.x , -highest_offset, highest_offset)
	position.y =clamp(start_pos.y + position.y , -highest_offset, highest_offset)
