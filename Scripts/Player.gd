extends Area2D

@export var speed = 400
var screen_size = Vector2.ZERO
var collider_size = Vector2.ZERO
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	collider_size = $Collider.shape.size
	
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if direction.length() > 0:
		direction = direction.normalized()
		$Skin.play()
	else:
		$Skin.stop()
	
	position += direction * speed * delta
	position.x = clamp(position.x, collider_size.x/2, screen_size.x - collider_size.x/2)
	position.y = clamp(position.y, collider_size.y/2, screen_size.y - collider_size.y/2)

func start(new_position):
	position = new_position
	show()
	$Collider.disabled = false	
