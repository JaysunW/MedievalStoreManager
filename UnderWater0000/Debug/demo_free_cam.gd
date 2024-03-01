extends Camera2D

var speed = 500
@export var zoom_update = Vector2(0.5,0.5)

func _process(delta):
	var direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up", "down"))
	if direction:
		position += direction * delta * speed
	var zoom_in = Input.is_action_just_released("mouse_wheel_up")
	var zoom_out = Input.is_action_just_released("mouse_wheel_down")

	if zoom_in:
		zoom_update += Vector2( 0.01, 0.01)
	elif zoom_out:
		zoom_update -= Vector2( 0.01, 0.01)
		
	zoom_update = Vector2( clamp(zoom_update.x,0.1,10), clamp(zoom_update.y,0.1,10))
	zoom = zoom_update
