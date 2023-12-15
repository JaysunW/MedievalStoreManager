extends Camera2D

const SPEED = 300

var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up", "down"))
	if direction:
		position += direction * delta * SPEED
