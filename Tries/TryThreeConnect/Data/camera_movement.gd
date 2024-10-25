extends Camera2D

@export var speed = 200
var max_movement = Vector2.ZERO

func _ready():
	max_movement = $"..".get_size() * 32

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move_vector = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down"))
	move_vector = position + move_vector * speed * delta
	var x_clamp = clamp(move_vector.x, 0, max_movement.x)
	var y_clamp = clamp(move_vector.y, 0, max_movement.y)
	position = Vector2(x_clamp, y_clamp)

func set_move_cap(input):
	max_movement = input
