extends Node2D

@onready var sprite = $RotationPoint/Sprite

var flip_counter = 1
var rotation_degree_list = [0,90]

var net_strength = 2
var cooldown = 0.5
var cooldown_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cooldown.wait_time = cooldown
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	if Input.is_action_pressed("left_mouse_button"):
		use_net()

# Use knife
func use_net():
	if not cooldown_active:
		sprite.flip_v = not sprite.flip_v
		cooldown_active = true
		$Cooldown.start()
		$RotationPoint.rotation = rotation_degree_list[flip_counter]
		flip_counter = (flip_counter + 1) % 2

# Cooldown timer
func _on_cooldown_timeout():
	cooldown_active = false
	pass # Replace with function body.
