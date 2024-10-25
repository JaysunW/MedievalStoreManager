extends Area2D

signal hit

@export var speed = 400
var screen_size = Vector2.ZERO
var max_jump = 80
var jump_dir = Vector2.ZERO
var changer = 1
var peaked = false
var is_grounded = true

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("spacebar") and is_grounded:
		is_grounded = false
	print(jump_dir.y)
	if not is_grounded:
		if jump_dir.y < max_jump and not peaked:
			print("a")
			changer = changer * 0.99
			changer = clamp(changer, 0.1, 1)
			jump_dir.y += changer
			position -= jump_dir * delta
		elif jump_dir.y > -max_jump*3:
			print("b")
			peaked = true
			changer = changer * 1.01
			changer = clamp(changer, 0.1, 1)
			jump_dir.y -= changer
			position -= jump_dir * delta
		else:
			print("c")
			is_grounded = true
			peaked = false
			jump_dir = Vector2.ZERO
			
	
	if direction.length() > 0:
		direction = direction.normalized()
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += direction * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if direction.x != 0:
		$AnimatedSprite2D.animation = "right"
		$Shadow.animation = "up"
		$Shadow.flip_v = false
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = direction.x < 0
	elif direction.y != 0:
		$AnimatedSprite2D.animation = "up"
		$Shadow.animation = "up"
		$AnimatedSprite2D.flip_v = direction.y > 0
		$Shadow.flip_v = direction.y > 0
		$AnimatedSprite2D.flip_h = false

func start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false	

func _on_body_entered(_body):
	if is_grounded:
		hide()
		$CollisionShape2D.set_deferred("disabled",true)
		emit_signal("hit")
