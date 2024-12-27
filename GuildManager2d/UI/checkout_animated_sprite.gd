extends AnimatedSprite2D

var target_position = null
var speed = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not target_position:
		return
	var dir = position.direction_to(target_position)
	position += delta * speed  * dir
	if position.distance_to(target_position) < 16:
		target_position = null
