extends Area2D

@export var speed = 400
@export var health = 100
@export var bullet_scene : PackedScene
var on_cooldown = false
var screen_size = Vector2.ZERO
var collider_size = Vector2.ZERO
signal hit


func _ready():
	collider_size = $Collider.shape.size
	screen_size = get_viewport_rect().size


func _process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("shoot") and not on_cooldown:
		shoot()
		
	if direction.length() > 0:
		direction = direction.normalized()
		$Skin.play()
	else:
		$Skin.stop()
	
	position += direction * speed * delta
	position.x = clamp(position.x, collider_size.x/2, screen_size.x - collider_size.x/2)
	position.y = clamp(position.y, collider_size.y/2, screen_size.y - collider_size.y/2)


func shoot():
	on_cooldown = true
	$Cooldown.start()
	var bullet = bullet_scene.instantiate()
	if owner != null:
		owner.add_child(bullet)
	else:
		add_child(bullet)
#	bullet.position = $ShootPosition.position
	bullet.transform = $ShootPosition.global_transform


func start(new_position):
	position = new_position
	show()
	$Collider.disabled = false	


func _on_cooldown_timeout():
	on_cooldown = false


func _on_area_entered(area):
	print("Hide")
	hide()
